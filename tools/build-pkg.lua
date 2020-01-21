#!/usr/bin/env lua

--[[
This file is part of MXE. See LICENSE.md for licensing information.

build-pkg, Build binary packages from MXE packages
Instructions: https://pkg.mxe.cc/

Requirements (see bootstrapped build below for non-debian systems):
    MXE (https://mxe.cc/#requirements-debian)
    apt-get install lua5.1 fakeroot dpkg dpkg-dev
Usage: lua tools/build-pkg.lua
Packages are written to `<codename>/*.tar.xz` files.
Debian packages are written to `<codename>/*.deb` files.

Build in directory /usr/lib/mxe
This directory can not be changed in .deb packages.

To prevent build-pkg from creating deb packages,
set environment variable MXE_BUILD_PKG_NO_DEBS to 1
In this case fakeroot and dpkg-deb are not needed.

To do a dry run without actually building any packages,
set environment variable MXE_BUILD_DRY_RUN to any value
Packages will be downloaded, but builds will be skipped.

To override the codename detection of `lsb_release -sc`, set
MXE_BUILD_PKG_CODENAME. This sets the output directory and name
mangling for the pool directory in the apt repo. Could be used to
create lowest-common-glibc based versions.

Set MXE_BUILD_PKG_VERSION_ID to add a git tag to each pkg version
string - defaults to YYYYMMDD build datestamp.

To switch off the second pass, set
MXE_BUILD_PKG_NO_SECOND_PASS to 1.
See https://github.com/mxe/mxe/issues/1111

To limit number of packages being built to x,
set environment variable MXE_BUILD_PKG_MAX_ITEMS to x.

To set list of MXE targets to build,
set environment variable MXE_BUILD_PKG_TARGETS to
the list of targets separated by space.
By default, all 4 major targets are built.

To set list of MXE packages to build,
set environment variable MXE_BUILD_PKG_PKGS to
the list of packages separated by space. This is similar
to a normal `make` invocation in that all dependencies
will be built, so list just the packages you require.
By default, all packages are built.

The following error:
> fakeroot, while creating message channels: Invalid argument
> This may be due to a lack of SYSV IPC support.
> fakeroot: error while starting the `faked' daemon.
can be caused by leaked ipc resources originating in fakeroot.
How to remove them: https://stackoverflow.com/a/4262545
Alternatively, to switch off using fakeroot (e.g. inside docker),
set MXE_BUILD_PKG_NO_FAKEROOT to 1.

Bootstrapped build (non-debian systems building without
deb pkgs to test print-deps-for-build-pkg, control files etc.):

export MXE_DIR=`pwd` && \
export BUILD=`$MXE_DIR/ext/config.guess` && \
rm -rf $MXE_DIR/usr $MXE_DIR/log $MXE_DIR/mxe-* && \
make -C $MXE_DIR lua \
    MXE_TARGETS=$BUILD \
    lua_TARGETS=$BUILD \
    PREFIX=$MXE_DIR/usr.lua && \
MXE_BUILD_PKG_CODENAME=trusty \
MXE_BUILD_PKG_TARGETS="i686-w64-mingw32.static" \
MXE_BUILD_PKG_PKGS=qt5 \
MXE_BUILD_DRY_RUN=1 \
MXE_BUILD_PKG_MAX_ITEMS= \
MXE_BUILD_PKG_NO_DEBS=1 \
MXE_BUILD_PKG_NO_SECOND_PASS=1 \
$MXE_DIR/usr.lua/$BUILD/bin/lua $MXE_DIR/tools/build-pkg.lua
]]

local max_items = tonumber(os.getenv('MXE_BUILD_PKG_MAX_ITEMS'))
local no_debs = os.getenv('MXE_BUILD_PKG_NO_DEBS')
local no_fakeroot = os.getenv('MXE_BUILD_PKG_NO_FAKEROOT')
local no_second_pass = os.getenv('MXE_BUILD_PKG_NO_SECOND_PASS')
local build_targets = os.getenv('MXE_BUILD_PKG_TARGETS')

local VERSION_ID = os.getenv('MXE_BUILD_PKG_VERSION_ID') or os.date("%Y%m%d")

local MAX_TRIES = 10

local GIT = 'git --work-tree=./usr/ --git-dir=./usr/.git '
local GIT_USER = '-c user.name="build-pkg" ' ..
    '-c user.email="build-pkg@mxe" '

local BLACKLIST = {
    '^usr/installed/check%-requirements$',
    -- usr/share/cmake is useful
    '^usr/share/doc/',
    '^usr/share/info/',
    '^usr/share/man/',
    '^usr/share/gcc',
    '^usr/share/gtk-doc',
    '^usr/[^/]+/share/doc/',
    '^usr/[^/]+/share/info/',

    -- usr/lib/nonetwork.so and
    -- usr/x86_64-unknown-linux-gnu/lib/nonetwork.so
    'lib/nonetwork.so',

    -- https://github.com/mxe/mxe/issues/1886#issuecomment-331719282
    'installed/.gitkeep',
    'lib/.gitkeep',
}

local TARGETS = {
    'i686-w64-mingw32.static',
    'x86_64-w64-mingw32.static',
    'i686-w64-mingw32.shared',
    'x86_64-w64-mingw32.shared',
}
if build_targets then
    TARGETS = {}
    for target in build_targets:gmatch('(%S+)') do
        table.insert(TARGETS, target)
    end
end

local function echo(fmt, ...)
    print(fmt:format(...))
    io.stdout:flush()
end

local function log(fmt, ...)
    echo('[build-pkg]\t' .. fmt, ...)
end

-- based on http://lua-users.org/wiki/SplitJoin
local function split(self, sep, nMax, plain)
    if not sep then
        sep = '%s+'
    end
    assert(sep ~= '')
    assert(nMax == nil or nMax >= 1)
    local aRecord = {}
    if self:len() > 0 then
        nMax = nMax or -1
        local nField = 1
        local nStart = 1
        local nFirst, nLast = self:find(sep, nStart, plain)
        while nFirst and nMax ~= 0 do
            aRecord[nField] = self:sub(nStart, nFirst - 1)
            nField = nField + 1
            nStart = nLast + 1
            nFirst, nLast = self:find(sep, nStart, plain)
            nMax = nMax - 1
        end
        aRecord[nField] = self:sub(nStart)
    end
    return aRecord
end

local function trim(str)
    local text = str:gsub("%s+$", "")
    text = text:gsub("^%s+", "")
    return text
end

local function isInArray(element, array)
    for _, member in ipairs(array) do
        if member == element then
            return true
        end
    end
    return false
end

local function sliceArray(list, nelements)
    nelements = nelements or #list
    local new_list = {}
    for i = 1, nelements do
        new_list[i] = list[i]
    end
    return new_list
end

local function concatArrays(...)
    local result = {}
    for _, array in ipairs({...}) do
        for _, elem in ipairs(array) do
            table.insert(result, elem)
        end
    end
    return result
end

local function isInString(substring, string)
    return string:find(substring, 1, true)
end

local function shell(cmd)
    local f = io.popen(cmd, 'r')
    local text = f:read('*all')
    f:close()
    return text
end

local function execute(cmd)
    if _VERSION == 'Lua 5.1' then
        return os.execute(cmd) == 0
    else
        -- Lua >= 5.2
        return os.execute(cmd)
    end
end

local MXE_DIR = trim(shell('pwd'))

-- for tar, try gtar and gnutar first
local tools = {}
local function tool(name)
    if tools[name] then
        return tools[name]
    end
    if execute(("g%s --help > /dev/null 2>&1"):format(name)) then
        tools[name] = 'g' .. name
    elseif execute(("gnu%s --help > /dev/null 2>&1"):format(name)) then
        tools[name] = 'gnu' .. name
    else
        tools[name] = name
    end
    return tools[name]
end

local function fileExists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

local function fileSize(name)
    local f = io.open(name, "r")
    local size = f:seek("end")
    io.close(f)
    return size
end

local function isSymlink(name)
    return shell(("ls -l %q"):format(name)):sub(1, 1) == "l"
end

local function writeFile(filename, data)
    local file = io.open(filename, 'w')
    file:write(data)
    file:close()
end

local NATIVE_TARGET = trim(shell("ext/config.guess"))
local function isCross(target)
    return target ~= NATIVE_TARGET
end

local function getArch()
    local cmd = "dpkg-architecture -qDEB_BUILD_ARCH 2> /dev/null"
    return trim(shell(cmd))
end
local ARCH = getArch()

-- return target and package from item name
local function parseItem(item)
    return item:match("([^~]+)~([^~]+)")
end

-- return item name from target and package
local function makeItem(target, package)
    return target .. '~' .. package
end

-- return several tables describing packages for all targets
-- * list of items
-- * map from item to list of deps (which are also items)
-- * map from item to version
-- Item is a string like "target~pkg"
local function getItems()
    local items = {}
    local item2deps = {}
    local item2ver = {}
    local cmd = '%s print-deps-for-build-pkg MXE_TARGETS=%q'
    cmd = cmd:format(tool 'make', table.concat(TARGETS, ' '))
    local make = io.popen(cmd)
    for line in make:lines() do
        local deps = split(trim(line))
        if deps[1] == 'for-build-pkg' then
            -- first value is marker 'for-build-pkg'
            table.remove(deps, 1)
            -- first value is name of package which depends on
            local item = table.remove(deps, 1)
            -- second value is version of package
            local ver = table.remove(deps, 1)
            table.insert(items, item)
            item2deps[item] = deps
            item2ver[item] = ver
            local target, _ = parseItem(item)
            for _, dep_item in ipairs(deps) do
                local target2, _ = parseItem(dep_item)
                if isCross(target2) and target2 ~= target then
                    log("Cross-target dependency %s -> %s",
                        target2, target)
                end
            end
        end
    end
    make:close()
    return items, item2deps, item2ver
end

local function getInstalled()
    local installed = {}
    local f = io.popen('ls usr/*/installed/*')
    local pattern = '/([^/]+)/installed/([^/]+)'
    for file in f:lines() do
        local target, pkg = assert(file:match(pattern))
        table.insert(installed, makeItem(target, pkg))
    end
    f:close()
    return installed
end

-- graph is a map from item to a list of destinations
local function transpose(graph)
    local transposed = {}
    for item, destinations in pairs(graph) do
        for _, dest in ipairs(destinations) do
            if not transposed[dest] then
                transposed[dest] = {}
            end
            table.insert(transposed[dest], item)
        end
    end
    return transposed
end

local function reverse(list)
    local n = #list
    local reversed = {}
    for i = 1, n do
        reversed[i] = list[n - i + 1]
    end
    return reversed
end

-- return items ordered in build order
-- this means, if item depends on item2, then
-- item2 precedes item1 in the list
local function sortForBuild(items, item2deps)
    local n = #items
    local item2followers = transpose(item2deps)
    -- Tarjan's algorithm
    -- https://en.wikipedia.org/wiki/Topological_sorting
    local build_list_reversed = {}
    local marked_permanently = {}
    local marked_temporarily = {}
    local function visit(item1)
        assert(not marked_temporarily[item1], 'not a DAG')
        if not marked_permanently[item1] then
            marked_temporarily[item1] = true
            local followers = item2followers[item1] or {}
            for _, item2 in ipairs(followers) do
                visit(item2)
            end
            marked_permanently[item1] = true
            marked_temporarily[item1] = false
            table.insert(build_list_reversed, item1)
        end
    end
    for _, item in ipairs(items) do
        if not marked_permanently[item] then
            visit(item)
        end
    end
    assert(#build_list_reversed == n)
    local build_list = reverse(build_list_reversed)
    assert(#build_list == n)
    return build_list
end

local function isDependency(item, dependency, item2deps)
    for _, dep in ipairs(item2deps[item]) do
        if dep == dependency then
            return true
        end
        if isDependency(dep, dependency, item2deps) then
            return true
        end
    end
    return false
end

local function makeItem2Index(build_list)
    local item2index = {}
    for index, item in ipairs(build_list) do
        assert(not item2index[item], 'Duplicate item')
        item2index[item] = index
    end
    return item2index
end

-- return if build_list is ordered topologically
local function isTopoOrdered(build_list, items, item2deps)
    if #build_list ~= #items then
        return false, 'Length of build_list is wrong'
    end
    local item2index = makeItem2Index(build_list)
    for item, deps in pairs(item2deps) do
        for _, dep in ipairs(deps) do
            if item2index[item] < item2index[dep] then
                return false, 'Item ' .. item ..
                    'is built before its dependency ' ..
                    dep
            end
        end
    end
    return true
end

local function isListed(file, list)
    for _, pattern in ipairs(list) do
        if file:match(pattern) then
            return true
        end
    end
    return false
end

local function isBlacklisted(file)
    return isListed(file, BLACKLIST)
end

local GIT_INITIAL = 'initial'
local GIT_ALL_PSEUDOITEM = 'all'

local function itemToBranch(item, pass)
    return pass .. '-' .. item:gsub('~', '_')
end

-- creates git repo in ./usr
local function gitInit()
    os.execute('mkdir -p ./usr')
    os.execute(GIT .. 'init --quiet')
end

local function gitTag(name)
    os.execute(GIT .. 'tag ' .. name)
end

local function gitConflicts()
    local cmd = GIT .. 'diff --name-only --diff-filter=U'
    local f = io.popen(cmd, 'r')
    local conflicts = {}
    for conflict in f:lines() do
        table.insert(conflicts, conflict)
    end
    f:close()
    return conflicts
end

-- git commits changes in ./usr
local function gitCommit(message)
    local cmd = GIT .. GIT_USER .. 'commit -a -m %q --quiet'
    assert(execute(cmd:format(message)))
end

local function gitCheckout(new_branch, deps, item2index, pass_of_deps)
    local main_dep = deps[1]
    if main_dep then
        main_dep = itemToBranch(main_dep, pass_of_deps)
    else
        main_dep = GIT_INITIAL
    end
    local cmd = '%s checkout -q -b %s %s'
    assert(execute(cmd:format(GIT, new_branch, main_dep)))
    -- merge with other dependencies
    for i = 2, #deps do
        local message = 'Merge with ' .. deps[i]
        local cmd2 = '%s %s merge -q %s -m %q'
        if not execute(cmd2:format(GIT,
            GIT_USER,
            itemToBranch(deps[i], pass_of_deps),
            message))
        then
            -- probably merge conflict
            local conflicts = table.concat(gitConflicts(), ' ')
            log('Merge conflicts: %s', conflicts)
            local cmd3 = '%s checkout --ours %s'
            assert(execute(cmd3:format(GIT, conflicts)))
            gitCommit(message)
        end
    end
    if #deps > 0 then
        -- prevent accidental rebuilds
        -- touch usr/*/installed/* files in build order
        -- see https://git.io/vuDJY
        local installed = getInstalled()
        table.sort(installed, function(x, y)
            return item2index[x] < item2index[y]
        end)
        for _, item in ipairs(installed) do
            local target, pkg = assert(parseItem(item))
            local cmd4 = 'touch -c usr/%s/installed/%s'
            execute(cmd4:format(target, pkg))
        end
    end
end

local function gitAdd()
    os.execute(GIT .. 'add --all --force .')
end

-- return two lists of filepaths under ./usr/
-- 1. new files
-- 2. changed files
local function gitStatus(item, item2deps, file2item)
    local new_files = {}
    local changed_files = {}
    local git_st = io.popen(GIT .. 'status --porcelain', 'r')
    for line in git_st:lines() do
        local status, file = line:match('(..) (.*)')
        assert(status:sub(2, 2) == ' ')
        status = trim(status)
        if file:sub(1, 1) == '"' then
            -- filename with a space is quoted by git
            file = file:sub(2, -2)
        end
        file = 'usr/' .. file
        if not fileExists(file) then
            if status == 'D' then
                local prev_owner = assert(file2item[file])
                if prev_owner == item then
                    log('Item %s removed %q installed by itself',
                        item, file)
                elseif isDependency(prev_owner, item, item2deps) then
                    log('Item %s removed %q installed by its follower %s',
                        item, file, prev_owner)
                else
                    log('Item %s removed %q installed by %s',
                        item, file, prev_owner)
                end
            elseif isSymlink(file) then
                log('Broken symlink: %q', file)
            else
                log('Missing file: %q', file)
            end
        elseif not isBlacklisted(file) then
            if status == 'A' then
                table.insert(new_files, file)
            elseif status == 'M' then
                table.insert(changed_files, file)
            else
                log('Strange git status: %q of %q',
                    status, file)
            end
        end
    end
    git_st:close()
    return new_files, changed_files
end

local function isValidBinary(target, file)
    local cmd = './usr/bin/%s-objdump -t %s > /dev/null 2>&1'
    return execute(cmd:format(target, file))
end

local function checkFile(file, item)
    local target, _ = parseItem(item)
    -- if it is PE32 file, it must have '.exe' in name
    local ext = file:sub(-4):lower()
    local cmd = 'file --dereference --brief %q'
    local file_type = trim(shell(cmd:format(file)))
    if ext == '.exe' then
        if not file_type:match('PE32') then
            log('File %s (%s) is %q. Remove .exe',
                file, item, file_type)
        end
    elseif ext == '.dll' then
        if not file_type:match('PE32.*DLL') then
            log('File %s (%s) is %q. Remove .dll',
                file, item, file_type)
        end
    elseif ext ~= '.bin' then
        -- .bin can be an executable or something else (font)
        if file_type:match('PE32') then
            log('File %s (%s) is %q. Add exe or dll',
                file, item, file_type)
        end
    end
    for _, t in ipairs(TARGETS) do
        if t ~= target and isInString(t, file) then
            log('File %s (%s): other target %s in name',
                file, item, t)
        end
    end
    if file:match('/lib/.*%.dll$') then
        log('File %s (%s): DLL in /lib/', file, item)
    end
    if file:match('%.dll$') or file:match('%.a$') then
        if isInString(target, file) and isCross(target) then
            -- cross-compiled
            if not isValidBinary(target, file) then
                log('File %s (%s): not recognized library',
                    file, item)
            end
        end
    end
end

local function checkFileList(files, item)
    local target, _ = parseItem(item)
    if target:match('shared') then
        local has_a, has_dll
        for _, file in ipairs(files) do
            file = file:lower()
            if file:match('%.a') then
                has_a = true
            end
            if file:match('%.dll') then
                has_dll = true
            end
        end
        if has_a and not has_dll then
            log('Shared item %s installs .a file ' ..
                'but no .dll', item)
        end
    end
end

local function removeEmptyDirs(item)
    -- removing an empty dir can reveal another one (parent)
    -- don't pass item to mute the log message
    local go_on = true
    while go_on do
        go_on = false
        local f = io.popen('find usr/* -empty -type d', 'r')
        for dir in f:lines() do
            if item then
                log("Remove empty directory %s created by %s",
                    dir, item)
            end
            os.remove(dir)
            go_on = true
        end
        f:close()
    end
end

local function prepareTree(pass, item, item2deps, prev_files, item2index)
    if pass == 'first' then
        gitCheckout(
            itemToBranch(item, pass),
            item2deps[item],
            item2index,
            pass
        )
    elseif pass == 'second' then
        -- Build item second time to check if it builds correctly if
        -- its followers and unrelated packages have been built.
        gitCheckout(
            itemToBranch(item, 'second'),
            {GIT_ALL_PSEUDOITEM},
            item2index,
            'first'
        )
        removeEmptyDirs()
        if prev_files then
            -- Remove files of item from previous build.
            for _, file in ipairs(prev_files) do
                os.remove(file)
            end
            gitAdd()
            gitCommit(("Remove %s to rebuild it"):format(item, pass))
        end
    else
        error("Unknown pass: " .. pass)
    end
end

local function comparePasses(item, new_files, prev_file2item, prev_files)
    local files_set = {}
    for _, file in ipairs(new_files) do
        if not prev_file2item[file] then
            log('Item %s installs a file on second pass only: %s',
                item, file)
        elseif prev_file2item[file] ~= item then
            log('File %s was installed by %s on first pass ' ..
                'and by %s - on the second pass',
                file, prev_file2item[file], item)
        end
        files_set[file] = true
    end
    if prev_files then
        -- prev_files is nil, if the first pass failed
        for _, file in ipairs(prev_files) do
            if not files_set[file] then
                log('Item %s installs a file on first pass only: %s',
                    item, file)
            end
        end
    end
    -- TODO compare contents of files (nm for binaries)
end

local function isBuilt(item, files)
    local target, pkg = parseItem(item)
    local INSTALLED = 'usr/%s/installed/%s'
    local installed = INSTALLED:format(target, pkg)
    for _, file in ipairs(files) do
        if file == installed then
            return true
        end
    end
    return false
end

-- builds package, returns list of new files
-- prev_files is passed only to second pass.
local function buildItem(item, item2deps, file2item, item2index, pass, prev_files)
    prepareTree(pass, item, item2deps, prev_files, item2index)
    local target, pkg = parseItem(item)
    local cmd = '%s %s~%s MXE_TARGETS=%s --jobs=1'
    os.execute(cmd:format(tool 'make', pkg, target, target))
    gitAdd()
    local new_files, changed_files = gitStatus(item, item2deps, file2item)
    if #new_files + #changed_files > 0 then
        gitCommit(("Build %s, pass %s"):format(item, pass))
    end
    if pass == 'first' then
        for _, file in ipairs(new_files) do
            checkFile(file, item)
            file2item[file] = item
        end
    elseif isBuilt(item, new_files) then
        comparePasses(item, new_files, file2item, prev_files)
    end
    for _, file in ipairs(changed_files) do
        checkFile(file, item)
        -- add a dependency on a package created this file
        local creator_item = assert(file2item[file])
        if not isInArray(creator_item, item2deps[item]) then
            table.insert(item2deps[item], creator_item)
        end
        log('Item %s (pass %s) changes %s, created by %s',
            item, pass, file, creator_item)
    end
    checkFileList(concatArrays(new_files, changed_files), item)
    removeEmptyDirs(item)
    return new_files
end

local function nameToDebian(item)
    item = item:gsub('[~_]', '-')
    local name = 'mxe-%s'
    return name:format(item)
end

local function protectVersion(ver)
    ver = ver:gsub('_', '.')
    if ver:sub(1, 1):match('%d') then
        return ver
    else
        -- version number does not start with digit
        return '0.' .. ver
    end
end

local CONTROL = [[Package: %s
Version: %s
Section: devel
Priority: optional
Architecture: %s%s
Installed-Size: %d
Maintainer: Boris Nagaev <bnagaev@gmail.com>
Homepage: https://mxe.cc/
Description: %s
 MXE (M cross environment) is a Makefile that compiles
 a cross compiler and cross compiles many free libraries
 such as SDL and Qt for various target platforms (MinGW).
 .
 %s
]]

local function debianControl(options)
    local deb_deps_str = ''
    if options.deps and #options.deps >= 1 then
        deb_deps_str = deb_deps_str ..
            '\n' .. 'Depends: ' ..
            table.concat(options.deps, ', ')
    end
    if options.recommends and #options.recommends >= 1 then
        deb_deps_str = deb_deps_str ..
            '\n' .. 'Recommends: ' ..
            table.concat(options.recommends, ', ')
    end
    local version = options.version .. '-' .. VERSION_ID
    return CONTROL:format(
        options.package,
        version,
        options.arch,
        deb_deps_str,
        math.ceil(options.size_bytes / 1024),
        options.description1,
        options.description2
    )
end

local function makePackage(name, files, deps, ver, d1, d2, dst, recommends)
    -- calculate size_bytes
    local size_bytes = 0
    for _, f in ipairs(files) do
        local size = math.ceil(fileSize(f) / 4096) * 4096
        size_bytes = size_bytes + size
    end
    -- dirname
    dst = dst or '.'
    local dirname = ('%s/%s_%s'):format(dst, name,
        protectVersion(ver))
    -- make .list file
    local list_path = ('%s/%s.list'):format(dst, name)
    writeFile(list_path, table.concat(files, "\n") .. "\n")
    -- make .tar.xz file
    local tar_name = dirname .. '.tar.xz'
    local cmd1 = '%s -T %s --owner=root --group=root -cJf %s'
    os.execute(cmd1:format(tool 'tar', list_path, tar_name))
    -- update list of files back from .tar.xz (see #1067)
    local cmd2 = '%s -tf %s'
    cmd2 = cmd2:format(tool 'tar', tar_name)
    local tar_reader = io.popen(cmd2, 'r')
    local files_str = tar_reader:read('*all')
    tar_reader:close()
    writeFile(list_path, files_str)
    -- make DEBIAN/control file
    local control_text = debianControl {
        package = name,
        version = protectVersion(ver),
        arch = ARCH,
        deps = deps,
        recommends = recommends,
        size_bytes = size_bytes,
        description1 = d1,
        description2 = d2,
    }
    writeFile(dirname .. ".deb-control", control_text)
    if not no_debs then
        -- unpack .tar.xz to the path for Debian
        local usr = dirname .. MXE_DIR
        os.execute(('mkdir -p %s'):format(usr))
        os.execute(('mkdir -p %s/DEBIAN'):format(dirname))
        -- use tar to copy files with paths
        local cmd3 = '%s -C %s -xf %s'
        if not no_fakeroot then
            cmd3 = 'fakeroot -s deb.fakeroot ' .. cmd3
        end
        os.execute(cmd3:format(tool 'tar', usr, tar_name))
        -- make DEBIAN/control file
        local control_fname = dirname .. '/DEBIAN/control'
        writeFile(control_fname, control_text)
        -- make .deb file
        local cmd4 = 'dpkg-deb -Zxz -b %s'
        if not no_fakeroot then
            cmd4 = 'fakeroot -i deb.fakeroot ' .. cmd4
        end
        os.execute(cmd4:format(dirname))
        -- cleanup
        os.execute(('rm -fr %s deb.fakeroot'):format(dirname))
    end
end

local D1 = "MXE package %s for %s"
local D2 = "This package contains the files for MXE package %s"

local function makeDeb(item, files, deps, ver, codename)
    local target, pkg = parseItem(item)
    local deb_pkg = nameToDebian(item)
    local d1 = D1:format(pkg, target)
    local d2 = D2:format(pkg)
    local deb_deps = {'mxe-requirements', 'mxe-source'}
    for _, dep in ipairs(deps) do
        table.insert(deb_deps, nameToDebian(dep))
    end
    makePackage(deb_pkg, files, deb_deps, ver, d1, d2, codename)
end

local function findForeignInstalls(item, files)
    for _, file in ipairs(files) do
        local pattern = 'usr/([^/]+)/installed/([^/]+)'
        local t, p = file:match(pattern)
        if t and p ~= '.gitkeep' then
            local item1 = makeItem(t, p)
            if item1 ~= item then
                log('Item %s built item %s', item, item1)
            end
        end
    end
end

-- script building HUGE_TIMES from MXE main log
-- https://gist.github.com/starius/3ea9d953b0c30df88aa7
local HUGE_TIMES = {
    [7] = {"ocaml-native", "ffmpeg", "boost"},
    [9] = {"openssl", "qtdeclarative", "ossim", "wxwidgets"},
    [12] = {"ocaml-core", "itk", "wt"},
    [19] = {"gcc", "qtbase", "llvm"},
    [24] = {"vtk", "vtk6", "openscenegraph"},
    [36] = {"openblas", "pcl", "oce"},
    [51] = {"qt"},
}

local PROGRESS = "[%3d/%d] " ..
    "The build is expected to complete in %0.1f hours, " ..
    "on %s"

local function progressPrinter(items)
    local pkg2time = {}
    for time, pkgs in pairs(HUGE_TIMES) do
        for _, pkg in ipairs(pkgs) do
            pkg2time[pkg] = time
        end
    end
    --
    local started_at = os.time()
    local sums = {}
    for i, item in ipairs(items) do
        local _, pkg = parseItem(item)
        local expected_time = pkg2time[pkg] or 1
        sums[i] = (sums[i - 1] or 0) + expected_time
    end
    local total_time = sums[#sums]
    local time_done = 0
    local pkgs_done = 0
    local printer = {}
    --
    function printer.advance(_, i)
        pkgs_done = i
        time_done = sums[i]
    end
    function printer.status(_)
        local now = os.time()
        local spent = now - started_at
        local predicted_duration = spent * total_time / time_done
        local predicted_end = started_at + predicted_duration
        local predicted_end_str = os.date("%c", math.floor(predicted_end + 0.5))
        local predicted_wait = predicted_end - now
        local predicted_wait_hours = predicted_wait / 3600.0
        return PROGRESS:format(pkgs_done, #items,
             predicted_wait_hours, predicted_end_str)
    end
    return printer
end

-- build all packages, save filelist to list file
-- prev_files is passed only to second pass.
local function buildPackages(items, item2deps, pass, prev_item2files)
    local broken = {}
    local unbroken = {}
    local file2item = {}
    local item2files = {}
    local function brokenDep(item)
        for _, dep in ipairs(item2deps[item]) do
            if broken[dep] then
                return dep
            end
        end
        return false
    end
    if pass == 'second' then
        assert(prev_item2files)
        -- fill file2item with data from prev_item2files
        for item, files in pairs(prev_item2files) do
            for _, file in ipairs(files) do
                file2item[file] = item
            end
        end
    end
    local item2index = makeItem2Index(items)
    local progress_printer = progressPrinter(items)
    for i, item in ipairs(items) do
        if not brokenDep(item) then
            local prev_files = prev_item2files and prev_item2files[item]
            local files = buildItem(
                item, item2deps, file2item, item2index, pass, prev_files
            )
            findForeignInstalls(item, files)
            if isBuilt(item, files) then
                item2files[item] = files
                table.insert(unbroken, item)
            else
                -- broken package
                broken[item] = true
                log('Item is broken: %s', item)
            end
        else
            broken[item] = true
            log('Item %s depends on broken item %s',
                item, brokenDep(item))
        end
        progress_printer:advance(i)
        echo(progress_printer:status())
    end
    return unbroken, item2files
end

local function makeDebs(items, item2deps, item2ver, item2files, codename)
    for _, item in ipairs(items) do
        local deps = assert(item2deps[item], item)
        local ver = assert(item2ver[item], item)
        local files = assert(item2files[item], item)
        makeDeb(item, files, deps, ver, codename)
    end
end

local function getMxeVersion()
    local index_html = io.open 'docs/index.html'
    local text = index_html:read('*all')
    index_html:close()
    return text:match('Release ([^<]+)')
end

local MXE_REQUIREMENTS_DESCRIPTION2 =
[[This package depends on all Debian dependencies of MXE.
 Other MXE packages depend on this package.]]

local function makeMxeRequirementsPackage(release)
    local name = 'mxe-requirements'
    local ver = getMxeVersion() .. '-' .. release
    -- MXE build requirements should not be strict dependencies here
    -- See https://github.com/mxe/mxe/issues/1537
    local deps = {}
    local recommends = {
        'autoconf', 'automake', 'autopoint', 'bash', 'bison',
        'bzip2', 'cmake', 'flex', 'gettext', 'git', 'g++',
        'gperf', 'intltool', 'libffi-dev', 'libtool',
        'libltdl-dev', 'libssl-dev', 'libxml-parser-perl',
        'make', 'openssl', 'patch', 'perl', 'p7zip-full',
        'pkg-config', 'python', 'ruby', 'sed',
        'unzip', 'wget', 'xz-utils',
        'g++-multilib', 'libc6-dev-i386',
    }
    if release ~= 'wheezy' then
        -- Jessie+
        table.insert(recommends, 'libtool-bin')
    end
    local dummy_name = 'mxe-requirements.dummy.' .. release
    local dummy = io.open(dummy_name, 'w')
    dummy:close()
    local files = {dummy_name}
    local d1 = "MXE requirements package"
    local d2 = MXE_REQUIREMENTS_DESCRIPTION2
    local dst = release
    makePackage(name, files, deps, ver, d1, d2, dst, recommends)
    os.remove(dummy_name)
end

local MXE_SOURCE_DESCRIPTION2 =
[[This package contains MXE source files.
 Other MXE packages depend on this package.]]

local function makeMxeSourcePackage(codename)
    local name = 'mxe-source'
    local ver = getMxeVersion() .. '-' .. codename
    -- dependencies
    local deps = {}
    local files = {
        'docs',
        'ext',
        'LICENSE.md',
        'Makefile',
        'mxe.github.mk',
        'mxe.patch.mk',
        'mxe.updates.mk',
        'plugins',
        'README.md',
        'src',
        'tools',
    }
    local d1 = "MXE source"
    local d2 = MXE_SOURCE_DESCRIPTION2
    makePackage(name, files, deps, ver, d1, d2, codename)
end

local function downloadPackages()
    local cmd = ('%s download -j 6 -k'):format(tool 'make')
    for i = 1, MAX_TRIES do
        log("Downloading packages. Attempt %d.", i)
        if execute(cmd) then
            log("All packages were downloaded.")
            return
        end
        log("Some packages failed to download.")
    end
    log("%d downloading attempts failed. Giving up.", MAX_TRIES)
    error('downloading failed')
end


local function main()
    local codename = os.getenv('MXE_BUILD_PKG_CODENAME')
        or trim(shell('(lsb_release -sc 2>/dev/null || uname -s) | tr [:upper:] [:lower:]'))
    assert(codename ~= '')
    log("Building for: %s", codename)
    assert(not io.open('usr/.git'), 'Remove usr/')
    local MXE_DIR_EXPECTED = '/usr/lib/mxe'
    if MXE_DIR ~= MXE_DIR_EXPECTED then
        log("Warning! Building in dir %s, not in %s",
            MXE_DIR, MXE_DIR_EXPECTED)
    end
    gitInit()
    assert(execute(("%s check-requirements nonet-lib print-git-oneline MXE_TARGETS=%q"):format(
        tool 'make', table.concat(TARGETS, ' '))))
    if not max_items then
        downloadPackages()
    end
    gitAdd()
    gitCommit('Initial commit')
    gitTag(GIT_INITIAL)
    local items, item2deps, item2ver = getItems()
    local build_list = sortForBuild(items, item2deps)
    assert(isTopoOrdered(build_list, items, item2deps))
    build_list = sliceArray(build_list, max_items)
    local first_pass_failed, second_pass_failed
    local unbroken, item2files = buildPackages(
        build_list, item2deps, 'first'
    )
    if #unbroken < #build_list then
        first_pass_failed = true
    end
    gitCheckout(
        itemToBranch(GIT_ALL_PSEUDOITEM, 'first'),
        unbroken,
        makeItem2Index(build_list),
        'first'
    )
    os.execute(('mkdir -p %s'):format(codename))
    makeDebs(unbroken, item2deps, item2ver, item2files, codename)
    makeMxeRequirementsPackage(codename)
    makeMxeSourcePackage(codename)
    if not no_second_pass then
        local unbroken_second = buildPackages(
            build_list, item2deps, 'second', item2files
        )
        if #unbroken_second < #build_list then
            second_pass_failed = true
        end
    end
    if first_pass_failed or second_pass_failed then
        local code = 1
        local close = true
        os.exit(code, close)
    end
end

main()
