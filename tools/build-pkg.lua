#!/usr/bin/env lua

-- This file is part of MXE.
-- See index.html for further information.

-- build-pkg, Build binary packages from MXE packages
-- Instructions: http://mxe.redjohn.tk

-- Requirements: MXE, lua, tsort, fakeroot, dpkg-deb.
-- Usage: lua tools/build-pkg.lua
-- Packages are written to `*.tar.xz` files.
-- Debian packages are written to `*.deb` files.

local max_packages = tonumber(os.getenv('MXE_MAX_PACKAGES'))

local ARCH = 'amd64'

local MXE_DIR = '/usr/lib/mxe'

local BLACKLIST = {
    '^usr/installed/check%-requirements$',
    '^usr/share/',
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

local target -- used by many functions

local function log(...)
    print(target, ...)
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

local function shell(cmd)
    local f = io.popen(cmd, 'r')
    local text = f:read('*all')
    f:close()
    return text
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

-- return set of all filepaths under ./usr/
local function findFiles()
    local files = {}
    local find = io.popen('find usr -type f -or -type l', 'r')
    for line in find:lines() do
        local file = trim(line)
        if not isBlacklisted(file) then
            files[file] = true
        end
    end
    find:close()
    return files
end

-- builds package, returns list of new files
local function buildPackage(pkg)
    local files_before = findFiles()
    local cmd = 'make %s MXE_TARGETS=%s --jobs=1'
    os.execute(cmd:format(pkg, target))
    local files_after = findFiles()
    local new_files = {}
    for file in pairs(files_after) do
        if not files_before[file] then
            table.insert(new_files, file)
        end
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
    local cmd = 'fakeroot -s deb.fakeroot tar -C %s -xf %s'
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
    -- make .deb file
    local cmd = 'fakeroot -i deb.fakeroot dpkg-deb -b %s'
    os.execute(cmd:format(dirname))
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
local function buildPackages(pkgs, pkg2deps)
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
            local files = buildPackage(pkg)
            if isBuilt(pkg, files) then
                saveFileList(pkg .. '.list', files)
                table.insert(unbroken, pkg)
            else
                -- broken package
                broken[pkg] = true
                log('The package is broken: ' .. pkg)
            end
        else
            broken[pkg] = true
            local msg = 'Package %s depends on broken %s'
            log(msg:format(pkg, brokenDep(pkg)))
        end
    end
    return unbroken
end

local function filterFiles(pkg, filter_common)
    local list = readFileList(pkg .. '.list')
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
    saveFileList(pkg .. '.list', noncommon_files)
end

local function makeCommonDeb(pkg, ver)
    local common_files = filterFiles(pkg, true)
    local list_path = pkg .. '.common-list'
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
        local list_path = pkg .. '.list'
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

local function clean()
    local cmd = 'make clean MXE_TARGETS=%s'
    os.execute(cmd:format(target))
end

local function buildForTarget(mxe_target)
    target = mxe_target
    local pkgs, pkg2deps, pkg2ver = getPkgs()
    local build_list = sortForBuild(pkgs, pkg2deps)
    if max_packages then
        while #build_list > max_packages do
            table.remove(build_list)
        end
    end
    clean()
    local unbroken = buildPackages(build_list, pkg2deps)
    makeDebs(unbroken, pkg2deps, pkg2ver)
    clean()
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
    local ver = getMxeVersion()
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
buildForTarget('i686-w64-mingw32.static')
buildForTarget('x86_64-w64-mingw32.static')
buildForTarget('i686-w64-mingw32.shared')
buildForTarget('x86_64-w64-mingw32.shared')
makeMxeRequirementsDeb('wheezy')
makeMxeRequirementsDeb('jessie')
