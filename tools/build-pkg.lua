#!/usr/bin/env lua

--[[
This file is part of MXE.
See index.html for further information.

build-pkg, Build binary packages from MXE packages
Instructions: http://mxe.redjohn.tk

Requirements: MXE, lua, tsort, fakeroot, dpkg-deb.
Usage: lua tools/build-pkg.lua
Packages are written to `*.tar.xz` files.
Debian packages are written to `*.deb` files.

Build in directory /usr/lib/mxe
This directory can not be changed in .deb packages
To change this directory, set environment variable
MXE_DIR to other directory.

To prevent build-pkg from creating deb packages,
set environment variable MXE_NO_DEBS to 1
In this case fakeroot and dpkg-deb are not needed.

To limit number of packages being built to x,
set environment variable MXE_MAX_ITEMS to x,

The following error:
> fakeroot, while creating message channels: Invalid argument
> This may be due to a lack of SYSV IPC support.
> fakeroot: error while starting the `faked' daemon.
can be caused by leaked ipc resources originating in fakeroot.
How to remove them: http://stackoverflow.com/a/4262545
]]

local max_items = tonumber(os.getenv('MXE_MAX_ITEMS'))
local no_debs = os.getenv('MXE_NO_DEBS')

local TODAY = os.date("%Y%m%d")

local MXE_DIR = os.getenv('MXE_DIR') or '/usr/lib/mxe'

local GIT = 'git --work-tree=./usr/ --git-dir=./usr/.git '

local BLACKLIST = {
    '^usr/installed/check%-requirements$',
    -- usr/share/cmake if useful
    '^usr/share/doc/',
    '^usr/share/info/',
    '^usr/share/man/',
    '^usr/share/gcc',
    '^usr/[^/]+/share/doc/',
    '^usr/[^/]+/share/info/',
}

local TARGETS = {
    'i686-w64-mingw32.static',
    'x86_64-w64-mingw32.static',
    'i686-w64-mingw32.shared',
    'x86_64-w64-mingw32.shared',
}

local function log(fmt, ...)
    print('[build-pkg]', fmt:format(...))
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

local function writeFile(filename, data)
    local file = io.open(filename, 'w')
    file:write(data)
    file:close()
end

local NATIVE_TARGET = trim(shell("ext/config.guess"))
local function isCross(target)
    return target ~= NATIVE_TARGET
end

local cmd = "dpkg-architecture -qDEB_BUILD_ARCH 2> /dev/null"
local ARCH = trim(shell(cmd))

-- return target and package from item name
local function parseItem(item)
    return item:match("([^~]+)~([^~]+)")
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

-- return items ordered in build order
-- this means, if item depends on item2, then
-- item2 preceeds item1 in the list
local function sortForBuild(items, item2deps)
    -- use sommand tsort
    local tsort_input_fname = os.tmpname()
    local tsort_input = io.open(tsort_input_fname, 'w')
    for _, item1 in ipairs(items) do
        for _, item2 in ipairs(item2deps[item1]) do
            tsort_input:write(item2 .. ' ' .. item1 .. '\n')
        end
    end
    tsort_input:close()
    --
    local build_list = {}
    local tsort = io.popen('tsort ' .. tsort_input_fname, 'r')
    for line in tsort:lines() do
        local item = trim(line)
        table.insert(build_list, item)
    end
    tsort:close()
    os.remove(tsort_input_fname)
    return build_list
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

-- creates git repo in ./usr
local function gitInit()
    os.execute('mkdir -p ./usr')
    os.execute(GIT .. 'init --quiet')
end

local function gitAdd()
    os.execute(GIT .. 'add .')
end

-- return two lists of filepaths under ./usr/
-- 1. new files
-- 2. changed files
local function gitStatus()
    local new_files = {}
    local changed_files = {}
    local git_st = io.popen(GIT .. 'status --porcelain', 'r')
    for line in git_st:lines() do
        local status, file = line:match('(..) (.*)')
        status = trim(status)
        if file:sub(1, 1) == '"' then
            -- filename with a space is quoted by git
            file = file:sub(2, -2)
        end
        file = 'usr/' .. file
        if not fileExists(file) then
            log('Missing file: %q', file)
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

-- git commits changes in ./usr
local function gitCommit(message)
    local cmd = GIT .. '-c user.name="build-pkg" ' ..
        '-c user.email="build-pkg@mxe" ' ..
        'commit -a -m %q --quiet'
    os.execute(cmd:format(message))
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
    if ext == '.bin' then
        -- can be an executable or something else (font)
    elseif ext == '.exe' then
        if not file_type:match('PE32') then
            log('File %s (%s) is %q. Remove .exe',
                file, item, file_type)
        end
    elseif ext == '.dll' then
        if not file_type:match('PE32.*DLL') then
            log('File %s (%s) is %q. Remove .dll',
                file, item, file_type)
        end
    else
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

-- builds package, returns list of new files
local function buildItem(item, item2deps, file2item)
    local target, pkg = parseItem(item)
    local cmd = '%s %s MXE_TARGETS=%s --jobs=1'
    os.execute(cmd:format(tool 'make', pkg, target))
    gitAdd()
    local new_files, changed_files = gitStatus()
    gitCommit(("Build %s"):format(item))
    for _, file in ipairs(new_files) do
        checkFile(file, item)
        file2item[file] = item
    end
    for _, file in ipairs(changed_files) do
        checkFile(file, item)
        -- add a dependency on a package created this file
        local creator_item = assert(file2item[file])
        if not isInArray(creator_item, item2deps[item]) then
            table.insert(item2deps[item], creator_item)
        end
        log('Item %s changes %s, created by %s',
            item, file, creator_item)
    end
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
Architecture: %s
Depends: %s
Maintainer: Boris Nagaev <bnagaev@gmail.com>
Homepage: http://mxe.cc
Description: %s
 MXE (M cross environment) is a Makefile that compiles
 a cross compiler and cross compiles many free libraries
 such as SDL and Qt for various target platforms (MinGW).
 .
 %s
]]

local function debianControl(options)
    local deb_deps_str = table.concat(options.deps, ', ')
    local version = options.version .. '-' .. TODAY
    return CONTROL:format(
        options.package,
        version,
        options.arch,
        deb_deps_str,
        options.description1,
        options.description2
    )
end

local function makePackage(name, files, deps, ver, d1, d2, dst)
    local dst = dst or '.'
    local dirname = ('%s/%s_%s'):format(dst, name,
        protectVersion(ver))
    -- make .list file
    local list_path = ('%s/%s.list'):format(dst, name)
    writeFile(list_path, table.concat(files, "\n"))
    -- make .tar.xz file
    local tar_name = dirname .. '.tar.xz'
    local cmd = '%s -T %s --owner=root --group=root -cJf %s'
    os.execute(cmd:format(tool 'tar', list_path, tar_name))
    -- make DEBIAN/control file
    local control_text = debianControl {
        package = name,
        version = protectVersion(ver),
        arch = ARCH,
        deps = deps,
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
        local cmd = '%s -C %s -xf %s'
        cmd = 'fakeroot -s deb.fakeroot ' .. cmd
        os.execute(cmd:format(tool 'tar', usr, tar_name))
        -- make DEBIAN/control file
        local control_fname = dirname .. '/DEBIAN/control'
        writeFile(control_fname, control_text)
        -- make .deb file
        local cmd = 'fakeroot -i deb.fakeroot dpkg-deb -b %s'
        os.execute(cmd:format(dirname))
        -- cleanup
        os.execute(('rm -fr %s deb.fakeroot'):format(dirname))
    end
end

local D1 = "MXE package %s for %s"
local D2 = "This package contains the files for MXE package %s"

local function makeDeb(item, files, deps, ver)
    local target, pkg = parseItem(item)
    local deb_pkg = nameToDebian(item)
    local d1 = D1:format(pkg, target)
    local d2 = D2:format(pkg)
    local deb_deps = {'mxe-requirements', 'mxe-source'}
    for _, dep in ipairs(deps) do
        table.insert(deb_deps, nameToDebian(dep))
    end
    makePackage(deb_pkg, files, deb_deps, ver, d1, d2)
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

-- build all packages, save filelist to list file
local function buildPackages(items, item2deps)
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
    for _, item in ipairs(items) do
        if not brokenDep(item) then
            local files = buildItem(item, item2deps, file2item)
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
    end
    return unbroken, item2files
end

local function makeDebs(items, item2deps, item2ver, item2files)
    for _, item in ipairs(items) do
        local deps = assert(item2deps[item], item)
        local ver = assert(item2ver[item], item)
        local files = assert(item2files[item], item)
        makeDeb(item, files, deps, ver)
    end
end

local function getMxeVersion()
    local index_html = io.open 'index.html'
    local text = index_html:read('*all')
    index_html:close()
    return text:match('Release ([^<]+)')
end

local MXE_REQUIREMENTS_DESCRIPTION2 =
[[This package depends on all Debian dependencies of MXE.
 Other MXE packages depend on this package.]]

local function makeMxeRequirementsPackage(release)
    os.execute(('mkdir -p %s'):format(release))
    local name = 'mxe-requirements'
    local ver = getMxeVersion() .. release
    -- dependencies
    local deps = {
        'autoconf', 'automake', 'autopoint', 'bash', 'bison',
        'bzip2', 'cmake', 'flex', 'gettext', 'git', 'g++',
        'gperf', 'intltool', 'libffi-dev', 'libtool',
        'libltdl-dev', 'libssl-dev', 'libxml-parser-perl',
        'make', 'openssl', 'patch', 'perl', 'p7zip-full',
        'pkg-config', 'python', 'ruby', 'scons', 'sed',
        'unzip', 'wget', 'xz-utils',
        'g++-multilib', 'libc6-dev-i386',
    }
    if release ~= 'wheezy' then
        -- Jessie+
        table.insert(deps, 'libtool-bin')
    end
    local files = {}
    local d1 = "MXE requirements package"
    local d2 = MXE_REQUIREMENTS_DESCRIPTION2
    local dst = release
    makePackage(name, files, deps, ver, d1, d2, dst)
end

local MXE_SOURCE_DESCRIPTION2 =
[[This package contains MXE source files.
 Other MXE packages depend on this package.]]

local function makeMxeSourcePackage()
    local name = 'mxe-source'
    local ver = getMxeVersion()
    -- dependencies
    local deps = {}
    local files = {
        'CNAME',
        'LICENSE.md',
        'Makefile',
        'README.md',
        'assets',
        'doc',
        'ext',
        'index.html',
        'src',
        'tools',
        'versions.json',
    }
    local d1 = "MXE source"
    local d2 = MXE_SOURCE_DESCRIPTION2
    makePackage(name, files, deps, ver, d1, d2)
end

assert(trim(shell('pwd')) == MXE_DIR,
    "Clone MXE to " .. MXE_DIR)
assert(execute(("%s check-requirements"):format(tool 'make')))
if not max_items then
    local cmd = ('%s download -j 6 -k'):format(tool 'make')
    while not execute(cmd) do end
end
gitInit()
local items, item2deps, item2ver = getItems()
local build_list = sortForBuild(items, item2deps)
build_list = sliceArray(build_list, max_items)
local unbroken, item2files = buildPackages(build_list, item2deps)
makeDebs(unbroken, item2deps, item2ver, item2files)
if not no_debs then
    makeMxeRequirementsPackage('wheezy')
    makeMxeRequirementsPackage('jessie')
end
makeMxeSourcePackage()
