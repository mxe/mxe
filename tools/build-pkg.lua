#!/usr/bin/env lua

-- This file is part of MXE.
-- See index.html for further information.

-- build-pkg, Build binary packages from MXE packages
-- Instructions: http://mxe.redjohn.tk

-- Requirements: MXE, lua, tsort, fakeroot, dpkg-deb.
-- Usage: lua tools/build-pkg.lua
-- Packages are written to `*.tar.xz` files.
-- Debian packages are written to `*.deb` files.

-- Build in directory /usr/lib/mxe
-- This directory can not be changed in .deb packages
-- To change this directory, set environment variable
-- MXE_DIR to other directory.

-- To prevent build-pkg from creating deb packages,
-- set environment variable MXE_NO_DEBS to 1
-- In this case fakeroot and dpkg-deb are not needed.

-- To limit number of packages being built to x,
-- set environment variable MXE_MAX_PACKAGES to x,

local max_packages = tonumber(os.getenv('MXE_MAX_PACKAGES'))
local no_debs = os.getenv('MXE_NO_DEBS')

local ARCH = 'amd64'

local MXE_DIR = os.getenv('MXE_DIR') or '/usr/lib/mxe'

local GIT = 'git --work-tree=./usr/ --git-dir=./usr/.git '

local BLACKLIST = {
    '^usr/installed/check%-requirements$',
    '^usr/share/',
    '^usr/[^/]+/share/doc/',
    '^usr/[^/]+/share/info/',
}

local COMMON_FILES = {
    ['gcc-isl'] = {
        '^usr/include/isl/',
        '^usr/lib/libisl%.',
        '^usr/lib/pkgconfig/isl.pc$',
    },
    ['gcc-mpc'] = {
        '^usr/include/mpc.h$',
        '^usr/lib/libmpc%.',
    },
    ['gcc-gmp'] = {
        '^usr/include/gmp.h$',
        '^usr/lib/libgmp%.',
    },
    ['gcc-mpfr'] = {
        '^usr/include/mpf2mpfr.h$',
        '^usr/include/mpfr.h$',
        '^usr/lib/libmpfr%.',
    },
    ['gcc'] = {
        '^usr/lib/libcc1%.',
    },
    ['yasm'] = {
        '^usr/include/libyasm',
        '^usr/lib/libyasm.a$',
    },
    ['ncurses'] = {
        '^usr/lib/pkgconfig/',
    },
    ['pkgconf'] = {
        '^usr/bin/config.guess$',
    },
}

local ARCH_FOR_COMMON = 'i686-w64-mingw32.static'

local TARGETS = {
    'i686-w64-mingw32.static',
    'x86_64-w64-mingw32.static',
    'i686-w64-mingw32.shared',
    'x86_64-w64-mingw32.shared',
}

local target -- used by many functions

local function log(fmt, ...)
    print('[build-pkg]', target, fmt:format(...))
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
    for _, item in ipairs(array) do
        if item == element then
            return true
        end
    end
    return false
end

local function shell(cmd)
    local f = io.popen(cmd, 'r')
    local text = f:read('*all')
    f:close()
    return text
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

-- return several tables describing packages
-- * list of packages
-- * map from package to list of deps
-- * map from package to version of package
local function getPkgs()
    -- create file deps.mk showing deps
    -- (make show-upstream-deps-% does not present in
    -- stable MXE)
    local deps_mk_content = [[
include Makefile
NOTHING:=
SPACE:=$(NOTHING) $(NOTHING)
NAME_WITH_UNDERSCORES:=$(subst $(SPACE),_,$(NAME))
print-deps:
	@$(foreach pkg,$(PKGS),echo \
		for-build-pkg $(pkg) \
		$(subst $(SPACE),-,$($(pkg)_VERSION)) \
		$($(pkg)_DEPS);)]]
    local deps_mk_file = io.open('deps.mk', 'w')
    deps_mk_file:write(deps_mk_content)
    deps_mk_file:close()
    local pkgs = {}
    local pkg2deps = {}
    local pkg2ver = {}
    local cmd = 'make -f deps.mk print-deps MXE_TARGETS=%s'
    cmd = cmd:format(target)
    local make = io.popen(cmd)
    for line in make:lines() do
        local deps = split(trim(line))
        if deps[1] == 'for-build-pkg' then
            -- first value is marker 'for-build-pkg'
            table.remove(deps, 1)
            -- first value is name of package which depends on
            local pkg = table.remove(deps, 1)
            -- second value is version of package
            local ver = table.remove(deps, 1)
            table.insert(pkgs, pkg)
            pkg2deps[pkg] = deps
            pkg2ver[pkg] = ver
        end
    end
    make:close()
    os.remove('deps.mk')
    return pkgs, pkg2deps, pkg2ver
end

-- return packages ordered in build order
-- this means, if pkg1 depends on pkg2, then
-- pkg2 preceeds pkg1 in the list
local function sortForBuild(pkgs, pkg2deps)
    -- use sommand tsort
    local tsort_input_fname = os.tmpname()
    local tsort_input = io.open(tsort_input_fname, 'w')
    for _, pkg1 in ipairs(pkgs) do
        for _, pkg2 in ipairs(pkg2deps[pkg1]) do
            tsort_input:write(pkg2 .. ' ' .. pkg1 .. '\n')
        end
    end
    tsort_input:close()
    --
    local build_list = {}
    local tsort = io.popen('tsort ' .. tsort_input_fname, 'r')
    for line in tsort:lines() do
        local pkg = trim(line)
        table.insert(build_list, pkg)
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

local function checkFile(file, pkg)
    -- if it is PE32 file, it must have '.exe' in name
    local ext = file:sub(-4):lower()
    local file_type0 = trim(shell(('file %q'):format(file)))
    local file_type = file_type0:match('^[^:]+: (.*)$')
    if file_type then
        local symlink = file_type:match('symbolic link')
        if ext == '.bin' then
            -- can be an executable or something else (font)
        elseif ext == '.exe' then
            if not file_type:match('PE32') and not symlink then
                log('File %s (%s) is %q. Remove .exe',
                    file, pkg, file_type)
            end
        elseif ext == '.dll' then
            if not file_type:match('PE32.*DLL') and not symlink then
                log('File %s (%s) is %q. Remove .dll',
                    file, pkg, file_type)
            end
        else
            if file_type:match('PE32') then
                log('File %s (%s) is %q. Add exe or dll',
                    file, pkg, file_type)
            end
        end
    else
        log("Can't get type of file %s (%s). file says %q",
            file, pkg, file_type0)
    end
    for _, t in ipairs(TARGETS) do
        if t ~= target and file:match(t) then
            log('File %s (%s): other target %s in name',
                file, pkg, t)
        end
    end
end

-- builds package, returns list of new files
local function buildPackage(pkg, pkg2deps, file2pkg)
    local cmd = 'make %s MXE_TARGETS=%s --jobs=1'
    os.execute(cmd:format(pkg, target))
    gitAdd()
    local new_files, changed_files = gitStatus()
    gitCommit(("Build %s for target %s"):format(pkg, target))
    for _, file in ipairs(new_files) do
        checkFile(file, pkg)
        file2pkg[file] = {pkg=pkg, target=target}
    end
    for _, file in ipairs(changed_files) do
        checkFile(file, pkg)
        -- add a dependency on a package created this file
        local creator_pkg = assert(file2pkg[file]).pkg
        local creator_target = assert(file2pkg[file]).target
        local level = ''
        if target == creator_target then
            if not isInArray(creator_pkg, pkg2deps[pkg]) then
                table.insert(pkg2deps[pkg], creator_pkg)
            end
        else
            level = 'error'
        end
        log('Package %s changes %s, created by %s (%s) %s',
            pkg, file, creator_pkg, creator_target, level)
    end
    return new_files
end

local function nameToDebian(pkg, t)
    local name = 'mxe-%s-%s'
    name = name:format(t or target, pkg)
    name = name:gsub('_', '-')
    return name
end

local function protectVersion(ver)
    ver = ver:gsub('_', '-')
    if ver:sub(1, 1):match('%d') then
        return ver
    else
        -- version number does not start with digit
        return '0.' .. ver
    end
end

local function listFile(pkg)
    return ('%s-%s.list'):format(target, pkg)
end

local CONTROL = [[Package: %s
Version: %s
Section: devel
Priority: optional
Architecture: %s
Depends: %s
Maintainer: Boris Nagaev <bnagaev@gmail.com>
Homepage: http://mxe.cc
Description: MXE package %s for %s
 MXE (M cross environment) is a Makefile that compiles
 a cross compiler and cross compiles many free libraries
 such as SDL and Qt for various target platforms (MinGW).
 .
 This package contains the files for MXE package %s.
]]

local function makeDeb(pkg, list_path, deps, ver, add_common)
    local deb_pkg = nameToDebian(pkg)
    local dirname = ('%s_%s'):format(deb_pkg,
        protectVersion(ver))
    -- make .tar.xz file
    local tar_name = dirname .. '.tar.xz'
    local cmd = 'tar -T %s --owner=0 --group=0 -cJf %s'
    os.execute(cmd:format(list_path, tar_name))
    -- unpack .tar.xz to the path for Debian
    local usr = dirname .. MXE_DIR
    os.execute(('mkdir -p %s'):format(usr))
    -- use tar to copy files with paths
    local cmd = 'tar -C %s -xf %s'
    if not no_debs then
        cmd = 'fakeroot -s deb.fakeroot ' .. cmd
    end
    os.execute(cmd:format(usr, tar_name))
    -- prepare dependencies
    local deb_deps = {'mxe-requirements'}
    for _, dep in ipairs(deps) do
        table.insert(deb_deps, nameToDebian(dep))
    end
    if add_common then
        table.insert(deb_deps, nameToDebian(pkg, 'common'))
    end
    local deb_deps_str = table.concat(deb_deps, ', ')
    -- make DEBIAN/control file
    os.execute(('mkdir -p %s/DEBIAN'):format(dirname))
    local control_fname = dirname .. '/DEBIAN/control'
    local control = io.open(control_fname, 'w')
    control:write(CONTROL:format(deb_pkg, protectVersion(ver),
        ARCH, deb_deps_str, pkg, target, pkg))
    control:close()
    if not no_debs then
        -- make .deb file
        local cmd = 'fakeroot -i deb.fakeroot dpkg-deb -b %s'
        os.execute(cmd:format(dirname))
    end
    -- cleanup
    os.execute(('rm -fr %s deb.fakeroot'):format(dirname))
end

local function readFileList(list_file)
    local list = {}
    for installed_file in io.lines(list_file) do
        table.insert(list, installed_file)
    end
    return list
end

local function saveFileList(list_file, list)
    local file = io.open(list_file, 'w')
    for _, installed_file in ipairs(list) do
        file:write(installed_file .. '\n')
    end
    file:close()
end

local function isBuilt(pkg, files)
    local INSTALLED = 'usr/%s/installed/%s'
    local installed = INSTALLED:format(target, pkg)
    for _, file in ipairs(files) do
        if file == installed then
            return true
        end
    end
    return false
end

-- build all packages, save filelist to file #pkg.list
local function buildPackages(pkgs, pkg2deps, file2pkg)
    local broken = {}
    local unbroken = {}
    local function brokenDep(pkg)
        for _, dep in ipairs(pkg2deps[pkg]) do
            if broken[dep] then
                return dep
            end
        end
        return false
    end
    for _, pkg in ipairs(pkgs) do
        if not brokenDep(pkg) then
            local files = buildPackage(pkg, pkg2deps, file2pkg)
            if isBuilt(pkg, files) then
                saveFileList(listFile(pkg), files)
                table.insert(unbroken, pkg)
            else
                -- broken package
                broken[pkg] = true
                log('The package is broken: %s', pkg)
            end
        else
            broken[pkg] = true
            log('Package %s depends on broken %s',
                pkg, brokenDep(pkg))
        end
    end
    return unbroken
end

local function filterFiles(pkg, filter_common)
    local list = readFileList(listFile(pkg))
    local list2 = {}
    local common_list = COMMON_FILES[pkg]
    for _, installed_file in ipairs(list) do
        local listed = isListed(installed_file, common_list)
        if listed == filter_common then
            table.insert(list2, installed_file)
        end
    end
    return list2
end

local function excludeCommon(pkg)
    local noncommon_files = filterFiles(pkg, false)
    saveFileList(listFile(pkg), noncommon_files)
end

local function makeCommonDeb(pkg, ver)
    local common_files = filterFiles(pkg, true)
    local list_path = ('common-%s.list'):format(pkg)
    saveFileList(list_path, common_files)
    local orig_target = target
    target = 'common'
    makeDeb(pkg, list_path, {}, ver)
    target = orig_target
end

local function makeDebs(pkgs, pkg2deps, pkg2ver)
    for _, pkg in ipairs(pkgs) do
        local deps = assert(pkg2deps[pkg], pkg)
        local ver = assert(pkg2ver[pkg], pkg)
        local list_path = listFile(pkg)
        local add_common = false
        if COMMON_FILES[pkg] then
            if target == ARCH_FOR_COMMON then
                makeCommonDeb(pkg, ver)
            end
            add_common = true
            excludeCommon(pkg)
        end
        makeDeb(pkg, list_path, deps, ver, add_common)
    end
end

local function buildForTarget(mxe_target, file2pkg)
    target = mxe_target
    local pkgs, pkg2deps, pkg2ver = getPkgs()
    local build_list = sortForBuild(pkgs, pkg2deps)
    if max_packages then
        while #build_list > max_packages do
            table.remove(build_list)
        end
    end
    local unbroken = buildPackages(build_list, pkg2deps, file2pkg)
    makeDebs(unbroken, pkg2deps, pkg2ver)
end

local function getMxeVersion()
    local index_html = io.open 'index.html'
    local text = index_html:read('*all')
    index_html:close()
    return text:match('Release ([^<]+)')
end

local MXE_REQUIREMENTS_CONTROL = [[Package: %s
Version: %s
Section: devel
Priority: optional
Architecture: %s
Depends: %s
Maintainer: Boris Nagaev <bnagaev@gmail.com>
Homepage: http://mxe.cc
Description: MXE requirements package
 MXE (M cross environment) is a Makefile that compiles
 a cross compiler and cross compiles many free libraries
 such as SDL and Qt for various target platforms (MinGW).
 .
 This package depends on all Debian dependencies of MXE.
 Other MXE packages depend on this package.
]]

local function makeMxeRequirementsDeb(release)
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
    local deps_str = table.concat(deps, ', ')
    -- directory
    local DIRNAME = '%s/%s_%s_%s'
    local dirname = DIRNAME:format(release, name, ver, ARCH)
    -- make DEBIAN/control file
    os.execute(('mkdir -p %s/DEBIAN'):format(dirname))
    local control_fname = dirname .. '/DEBIAN/control'
    local control = io.open(control_fname, 'w')
    control:write(MXE_REQUIREMENTS_CONTROL:format(name,
        ver, ARCH, deps_str))
    control:close()
    -- make .deb file
    local cmd = 'fakeroot -i deb.fakeroot dpkg-deb -b %s'
    os.execute(cmd:format(dirname))
    -- cleanup
    os.execute(('rm -fr %s deb.fakeroot'):format(dirname))
end

assert(trim(shell('pwd')) == MXE_DIR,
    "Clone MXE to " .. MXE_DIR)
gitInit()
local file2pkg = {}
for _, t in ipairs(TARGETS) do
    buildForTarget(t, file2pkg)
end
if not no_debs then
    makeMxeRequirementsDeb('wheezy')
    makeMxeRequirementsDeb('jessie')
end
