# This file is part of MXE. See LICENSE.md for licensing information.

MAKEFILE := $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
TOP_DIR  := $(patsubst %/,%,$(dir $(MAKEFILE)))
EXT_DIR  := $(TOP_DIR)/ext

# GNU Make Standard Library (https://gmsl.sourceforge.io/)
# See docs/gmsl.html for further information
include $(EXT_DIR)/gmsl

MXE_TRIPLETS       := i686-w64-mingw32 x86_64-w64-mingw32
MXE_LIB_TYPES      := static shared
MXE_TARGET_LIST    := $(strip $(foreach TRIPLET,$(MXE_TRIPLETS),\
                          $(addprefix $(TRIPLET).,$(MXE_LIB_TYPES))))
MXE_TARGETS        := i686-w64-mingw32.static
.DEFAULT_GOAL      := all-filtered

DEFAULT_MAX_JOBS   := 6
PRINTF_COL_1_WIDTH := 13
SOURCEFORGE_MIRROR := downloads.sourceforge.net
MXE_MIRROR         := https://mirror.mxe.cc/pkg
PKG_MIRROR         := https://mxe-pkg.s3.amazonaws.com
PKG_CDN            := http://d1yihgixbnrglp.cloudfront.net
# reorder as required, ensuring final one is a http fallback
MIRROR_SITES       := MXE_MIRROR PKG_MIRROR PKG_CDN

PWD        := $(shell pwd)
SHELL      := bash

MXE_TMP := $(PWD)

BUILD_CC   := $(shell (gcc --help >/dev/null 2>&1 && echo gcc) || (clang --help >/dev/null 2>&1 && echo clang))
BUILD_CXX  := $(shell (g++ --help >/dev/null 2>&1 && echo g++) || (clang++ --help >/dev/null 2>&1 && echo clang++))
DATE       := $(shell gdate --help >/dev/null 2>&1 && echo g)date
INSTALL    := $(shell ginstall --help >/dev/null 2>&1 && echo g)install
LIBTOOL    := $(shell glibtool --help >/dev/null 2>&1 && echo g)libtool
LIBTOOLIZE := $(shell glibtoolize --help >/dev/null 2>&1 && echo g)libtoolize
OPENSSL    := openssl
PATCH      := $(shell gpatch --help >/dev/null 2>&1 && echo g)patch
PYTHON2    := $(or $(shell ([ `python -c "import sys; print('{0[0]}'.format(sys.version_info))"` == 2 ] && echo python) 2>/dev/null || \
                           which python2 2>/dev/null || \
                           which python2.7 2>/dev/null), \
                   $(warning Warning: python v2 not found (or default python changed to v3))\
                   $(shell touch check-requirements-failed))
SED        := $(shell gsed --help >/dev/null 2>&1 && echo g)sed
SORT       := $(shell gsort --help >/dev/null 2>&1 && echo g)sort
DEFAULT_UA := $(shell wget --version | $(SED) -n 's,GNU \(Wget\) \([0-9.]*\).*,\1/\2,p')
WGET_TOOL   = wget
WGET        = $(WGET_TOOL) --user-agent='$(or $($(1)_UA),$(DEFAULT_UA))' -t 2 --timeout=6

REQUIREMENTS := autoconf automake autopoint bash bison bzip2 flex \
                $(BUILD_CC) $(BUILD_CXX) gperf intltoolize $(LIBTOOL) \
                $(LIBTOOLIZE) lzip $(MAKE) $(OPENSSL) $(PATCH) $(PERL) python \
                ruby $(SED) $(SORT) unzip wget xz 7za gdk-pixbuf-csource

PREFIX     := $(PWD)/usr
LOG_DIR    := $(PWD)/log
GITS_DIR   := $(PWD)/gits
GIT_HEAD   := $(shell git rev-parse HEAD)
TIMESTAMP  := $(shell date +%Y%m%d_%H%M%S)
PKG_DIR    := $(PWD)/pkg
TMP_DIR     = $(MXE_TMP)/tmp-$(1)
BUILD      := $(shell '$(EXT_DIR)/config.guess')
PATH       := $(PREFIX)/$(BUILD)/bin:$(PREFIX)/bin:$(shell echo $$PATH | $(SED) -e 's,:\.$$,,' -e 's,\.:,,g')

# set to empty or $(false) to disable stripping
STRIP_TOOLCHAIN := $(true)
STRIP_LIB       := $(false)
STRIP_EXE       := $(true)

# disable by setting MXE_USE_CCACHE
MXE_USE_CCACHE      := mxe
MXE_CCACHE_DIR      := $(PWD)/.ccache
MXE_CCACHE_BASE_DIR := $(PWD)

# define some whitespace variables
define newline


endef

\n    := $(newline)
comma := ,
null  :=
space := $(null) $(null)
repeat = $(subst x,$(1),$(subst $(space),,$(call int_encode,$(2))))

PLUGIN_HEADER = $(info $(shell printf '%-$(PRINTF_COL_1_WIDTH)s %s\n' [plugin] $(dir $(lastword $(MAKEFILE_LIST)))))

MXE_DISABLE_DOC_OPTS = \
    ac_cv_prog_HAVE_DOXYGEN="false" \
    --enable-doc=no \
    --enable-gtk-doc=no \
    --enable-gtk-doc-html=no \
    --enable-gtk-doc-pdf=no \
    --{docdir,infodir,mandir,with-html-dir}='$(BUILD_DIR).sink' \
    --disable-doxygen

MXE_CONFIGURE_OPTS = \
    --host='$(TARGET)' \
    --build='$(BUILD)' \
    --prefix='$(PREFIX)/$(TARGET)' \
    $(if $(BUILD_STATIC), \
        --enable-static --disable-shared , \
        --disable-static --enable-shared ) \
    $(MXE_DISABLE_DOC_OPTS)

PKG_CONFIGURE_OPTS = \
    $(_$(PKG)_CONFIGURE_OPTS) \
    $($(PKG)_CONFIGURE_OPTS)

# GCC threads and exceptions
MXE_GCC_THREADS = \
    $(if $(findstring win32,$(or $(TARGET),$(1))),win32,posix)

# allowed exception handling for targets
# default (first item) and alternate, revisit if gcc/mingw-w64 change defaults
i686-w64-mingw32_EH   := sjlj dw2
x86_64-w64-mingw32_EH := seh sjlj

# functions to determine exception handling from user-specified target
# $(or $(TARGET),$(1)) allows use as both function and inline snippet
TARGET_EH_LIST = $($(firstword $(call split,.,$(or $(TARGET),$(1))))_EH)
DEFAULT_EH     = $(firstword $(TARGET_EH_LIST))
GCC_EXCEPTIONS = \
    $(lastword $(DEFAULT_EH) \
               $(filter $(TARGET_EH_LIST),$(call split,.,$(or $(TARGET),$(1)))))
MXE_GCC_EXCEPTION_OPTS = \
    $(if $(call seq,sjlj,$(GCC_EXCEPTIONS)),--enable-sjlj-exceptions) \
    $(if $(call seq,dw2,$(GCC_EXCEPTIONS)),--disable-sjlj-exceptions)


# Append these to the "make" and "make install" steps of autotools packages
# in order to neither build nor install unwanted binaries, manpages,
# infopages and API documentation (reduces build time and disk space usage).
# NOTE: We don't include bin_SCRIPTS (and variations), since many packages
# install files such as pcre-config (which we do want to be installed).

MXE_DISABLE_PROGRAMS = \
    dist_bin_SCRIPTS= \
    bin_PROGRAMS= \
    sbin_PROGRAMS= \
    noinst_PROGRAMS= \
    check_PROGRAMS=

MXE_DISABLE_DOCS = \
    man_MANS= \
    man1_MANS= \
    man2_MANS= \
    man3_MANS= \
    man4_MANS= \
    man5_MANS= \
    man6_MANS= \
    man7_MANS= \
    man8_MANS= \
    man9_MANS= \
    dist_man_MANS= \
    dist_man1_MANS= \
    dist_man2_MANS= \
    dist_man3_MANS= \
    dist_man4_MANS= \
    dist_man5_MANS= \
    dist_man6_MANS= \
    dist_man7_MANS= \
    dist_man8_MANS= \
    dist_man9_MANS= \
    nodist_man_MANS= \
    nodist_man1_MANS= \
    nodist_man2_MANS= \
    nodist_man3_MANS= \
    nodist_man4_MANS= \
    nodist_man5_MANS= \
    nodist_man6_MANS= \
    nodist_man7_MANS= \
    nodist_man8_MANS= \
    nodist_man9_MANS= \
    notrans_dist_man_MANS= \
    MANLINKS= \
    info_TEXINFOS= \
    doc_DATA= \
    dist_doc_DATA= \
    html_DATA= \
    dist_html_DATA=

MXE_DISABLE_CRUFT = $(MXE_DISABLE_PROGRAMS) $(MXE_DISABLE_DOCS)

MAKE_SHARED_FROM_STATIC = \
	'$(TOP_DIR)/tools/make-shared-from-static' \
	$(if $(findstring mingw,$(TARGET)),--windowsdll) \
	--ar '$(TARGET)-ar' \
	--ld '$(TARGET)-gcc' \
	--install '$(INSTALL)' \
	--libdir '$(PREFIX)/$(TARGET)/lib' \
	--bindir '$(PREFIX)/$(TARGET)/bin'

define AUTOTOOLS_CONFIGURE
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
endef

define AUTOTOOLS_MAKE
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_DOCS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_DOCS)
endef

define AUTOTOOLS_BUILD
    $(AUTOTOOLS_CONFIGURE)
    $(AUTOTOOLS_MAKE)
endef

define CMAKE_TEST
    # test cmake
    mkdir '$(BUILD_DIR).test-cmake'
    cd '$(BUILD_DIR).test-cmake' && '$(TARGET)-cmake' \
        -DPKG=$(PKG) \
        -DPKG_VERSION=$($(PKG)_VERSION) \
        '$(PWD)/src/cmake/test'
    $(MAKE) -C '$(BUILD_DIR).test-cmake' -j 1 install
endef

# include github related functions
include $(PWD)/mxe.github.mk

# shared lib preload to disable networking, enable faketime etc
PRELOAD_VARS := LD_PRELOAD DYLD_FORCE_FLAT_NAMESPACE DYLD_INSERT_LIBRARIES

# use a minimal whitelist of safe environment variables
# basic working shell environment and mxe variables
# see http://www.linuxfromscratch.org/lfs/view/stable/chapter04/settingenvironment.html
ENV_WHITELIST := EDITOR HOME LANG LC_% PATH %PROXY %proxy PS1 TERM
ENV_WHITELIST += MAKE% MXE% $(PRELOAD_VARS) WINEPREFIX

# OS/Distro related issues - "unsafe" but practical
# 1. https://github.com/mxe/mxe/issues/697
ENV_WHITELIST += ACLOCAL_PATH LD_LIBRARY_PATH

unexport $(filter-out $(ENV_WHITELIST),$(shell env | cut -d '=' -f1))

SHORT_PKG_VERSION = \
    $(word 1,$(subst ., ,$($(1)_VERSION))).$(word 2,$(subst ., ,$($(1)_VERSION)))

UNPACK_ARCHIVE = \
    $(if $(filter %.tar,     $(1)),tar xf  '$(1)', \
    $(if $(filter %.tgz,     $(1)),tar xzf '$(1)', \
    $(if $(filter %.tar.gz,  $(1)),tar xzf '$(1)', \
    $(if $(filter %.tar.Z,   $(1)),tar xzf '$(1)', \
    $(if $(filter %.tbz2,    $(1)),tar xjf '$(1)', \
    $(if $(filter %.tar.bz2, $(1)),tar xjf '$(1)', \
    $(if $(filter %.tar.lz,  $(1)),lzip -dc '$(1)'| tar xf -, \
    $(if $(filter %.tar.lzma,$(1)),xz -dc -F lzma '$(1)' | tar xf -, \
    $(if $(filter %.txz,     $(1)),xz -dc '$(1)' | tar xf -, \
    $(if $(filter %.tar.xz,  $(1)),xz -dc '$(1)' | tar xf -, \
    $(if $(filter %.7z,      $(1)),7za x '$(1)', \
    $(if $(filter %.zip,     $(1)),unzip -q '$(1)', \
    $(if $(filter %.deb,     $(1)),ar x '$(1)' && tar xf data.tar*, \
    $(error Unknown archive format: $(1)))))))))))))))

UNPACK_PKG_ARCHIVE = \
    $(call UNPACK_ARCHIVE,$(PKG_DIR)/$($(1)_FILE))

# some shortcuts for awareness of MXE_PLUGIN_DIRS
# all files for extension plugins will be considered for outdated checks
PKG_MAKEFILES = $(realpath $(sort $(wildcard $(addsuffix /$(1).mk, $(MXE_PLUGIN_DIRS)))))
PKG_TESTFILES = $(realpath $(sort $(wildcard $(addsuffix /$(1)-test*, $(MXE_PLUGIN_DIRS)))))
# allow packages to specify a list of zero or more patches
PKG_PATCHES   = $(if $(findstring undefined,$(origin $(1)_PATCHES)), \
                    $(realpath $(sort $(wildcard $(addsuffix /$(1)-[0-9]*.patch, $(MXE_PLUGIN_DIRS))))) \
                $(else), \
                    $($(1)_PATCHES))

define PREPARE_PKG_SOURCE
    $(if $($(1)_SOURCE_TREE),\
        ln -si '$(realpath $($(1)_SOURCE_TREE))' '$(2)/$($(1)_SUBDIR)'
    $(else),\
        cd '$(2)' && $(call UNPACK_PKG_ARCHIVE,$(1))
        cd '$(2)/$($(1)_SUBDIR)'
        $(foreach PKG_PATCH,$($(1)_PATCHES),
            (cd '$(2)/$($(1)_SUBDIR)' && $(PATCH) -p1 -u) < $(PKG_PATCH))
    )
endef

PKG_CHECKSUM = \
    $(OPENSSL) dgst -sha256 '$(or $(2),$(PKG_DIR)/$($(1)_FILE))' 2>/dev/null | $(SED) -n 's,^.*\([0-9a-f]\{64\}\)$$,\1,p'

CHECK_PKG_ARCHIVE = \
    $(if $($(1)_SOURCE_TREE),\
        $(PRINTF_FMT) '[local]' '$(1)' '$($(1)_SOURCE_TREE)' | $(RTRIM)\
    $(else),$(if $(SKIP_CHECHSUM),true, \
        [ '$($(1)_CHECKSUM)' == "`$$(call PKG_CHECKSUM,$(1),$(2))`" ]\
    ))

ESCAPE_PKG = \
	echo '$($(1)_FILE)' | perl -lpe 's/([^A-Za-z0-9])/sprintf("%%%02X", ord($$$$1))/seg'

BACKUP_DOWNLOAD = \
    (echo "MXE Warning! Downloading $(1) from backup." >&2 && \
    ($(foreach SITE,$(MIRROR_SITES), \
        $(WGET) -O '$(TMP_FILE)' $($(SITE))/`$(call ESCAPE_PKG,$(1))`_$($(1)_CHECKSUM) || ) false))

DOWNLOAD_PKG_ARCHIVE = \
    $(eval TMP_FILE := $(PKG_DIR)/.tmp-$($(1)_FILE)) \
    $(if $($(1)_SOURCE_TREE),\
        true\
    $(else),\
        mkdir -p '$(PKG_DIR)' && ( \
            ($(WGET) -T 30 -t 3 -O '$(TMP_FILE)' '$($(1)_URL)' && \
             $(call CHECK_PKG_ARCHIVE,$(1),'$(TMP_FILE)')) \
            $(if $($(1)_URL_2), \
                || (echo "MXE Warning! Downloading $(1) from second URL." >&2 && \
                    $(WGET) -T 30 -t 3 -O '$(TMP_FILE)' '$($(1)_URL_2)' && \
                    $(call CHECK_PKG_ARCHIVE,$(1),'$(TMP_FILE)'))) \
            $(if $(MXE_NO_BACKUP_DL),, \
                || $(BACKUP_DOWNLOAD)) \
        ) && cat '$(TMP_FILE)' \
        $(if $($(1)_FIX_GZIP), \
            | gzip -d | gzip -9n, \
            ) \
        > '$(PKG_DIR)/$($(1)_FILE)' && \
        $(if $(CREATE_SUFFIXED_ARCHIVE),cp '$(PKG_DIR)/$($(1)_FILE)' '$(PKG_DIR)/$($(1)_FILE)_$($(1)_CHECKSUM)' &&) \
        rm '$(TMP_FILE)' || \
        ( echo; \
          echo 'Download failed!'; \
          echo; \
          rm -f '$(PKG_DIR)/$($(1)_FILE)' '$(TMP_FILE)'; )\
    )

# open issue from 2002:
# https://savannah.gnu.org/bugs/?712
ifneq ($(words $(PWD)),1)
    $(error GNU Make chokes on paths with spaces)
endif

# dollar signs also cause troubles
ifneq (,$(findstring $$,$(PWD)))
    $(error GNU Make chokes on paths with dollar signs)
endif

ifeq ($(IGNORE_SETTINGS),yes)
    $(info [ignore settings.mk])
else ifeq ($(wildcard $(PWD)/settings.mk),$(PWD)/settings.mk)
    include $(PWD)/settings.mk
else
    $(info [create settings.mk])
    $(shell { \
        echo '# This is a template of configuration file for MXE. See'; \
        echo '# docs/index.html for more extensive documentations.'; \
        echo; \
        echo '# This variable controls the number of compilation processes'; \
        echo '# within one package ("intra-package parallelism").'; \
        echo '#JOBS := $(JOBS)'; \
        echo; \
        echo '# This variable controls where intermediate files are created'; \
        echo '# this is necessary when compiling inside a virtualbox shared'; \
        echo '# directory. Some commands like strip fail in there with Protocol error'; \
        echo '# default is the current directory'; \
        echo '#MXE_TMP := /tmp'; \
        echo; \
        echo '# This variable controls the targets that will build.'; \
        echo '#MXE_TARGETS := $(MXE_TARGET_LIST)'; \
        echo; \
        echo '# This variable controls which plugins are in use.'; \
        echo '# See plugins/README.md for further information.'; \
        echo '#override MXE_PLUGIN_DIRS += plugins/apps plugins/native'; \
        echo; \
        echo '# This variable controls the download mirror for SourceForge,'; \
        echo '# when it is used. Enabling the value below means auto.'; \
        echo '#SOURCEFORGE_MIRROR := downloads.sourceforge.net'; \
        echo; \
        echo '# The three lines below makes `make` build these "local'; \
        echo '# packages" instead of all packages.'; \
        echo '#LOCAL_PKG_LIST := boost curl file flac lzo pthreads vorbis wxwidgets'; \
        echo '#.DEFAULT_GOAL  := local-pkg-list'; \
        echo '#local-pkg-list: $$(LOCAL_PKG_LIST)'; \
    } >'$(PWD)/settings.mk')
endif

ifneq ($(LOCAL_PKG_LIST),)
    .DEFAULT_GOAL := local-pkg-list
    $(info [pkg-list]  $(LOCAL_PKG_LIST))
endif

# Numeric min and max list functions
LIST_NMAX   = $(shell echo '$(strip $(1))' | tr ' ' '\n' | sort -n | tail -1)
LIST_NMIN   = $(shell echo '$(strip $(1))' | tr ' ' '\n' | sort -n | head -1)

NPROCS := $(shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)
JOBS   := $(call LIST_NMIN, $(DEFAULT_MAX_JOBS) $(NPROCS))

# Core packages.
override MXE_PLUGIN_DIRS := $(realpath $(TOP_DIR)/src) $(MXE_PLUGIN_DIRS)

# Build native requirements for certain systems
OS_SHORT_NAME   := $(call lc,$(shell lsb_release -sc 2>/dev/null || uname -s))
override MXE_PLUGIN_DIRS += $(realpath $(TOP_DIR)/plugins/native/$(OS_SHORT_NAME))

.PHONY: check-requirements
define CHECK_REQUIREMENT
    @if ! ( $(1) --help || $(1) help ) &>/dev/null; then \
        echo 'Missing requirement: $(1)'; \
        touch check-requirements-failed; \
    fi

endef
define CHECK_REQUIREMENT_VERSION
    @if ! $(1) --version | head -1 | grep ' \($(2)\)$$' >/dev/null; then \
        echo 'Wrong version of requirement: $(1)'; \
        touch check-requirements-failed; \
    fi

endef

%/.gitkeep:
	+@mkdir -p '$(dir $@)'
	@touch '$@'

check-requirements: $(PREFIX)/installed/check-requirements
$(PREFIX)/installed/check-requirements: $(MAKEFILE) | $(PREFIX)/installed/.gitkeep
	@echo '[check reqs]'
	$(foreach REQUIREMENT,$(REQUIREMENTS),$(call CHECK_REQUIREMENT,$(REQUIREMENT)))
	$(call CHECK_REQUIREMENT_VERSION,autoconf,2\.6[8-9]\|2\.[7-9][0-9])
	$(call CHECK_REQUIREMENT_VERSION,automake,1\.11\.[3-9]\|1\.[1-9][2-9]\(\.[0-9]\+\)\?)
	@if [ -e check-requirements-failed ]; then \
	    echo; \
	    echo 'Please have a look at "docs/index.html" to ensure'; \
	    echo 'that your system meets all requirements.'; \
	    echo; \
	    rm check-requirements-failed; \
	    exit 1; \
	fi
	@touch '$@'

.PHONY: print-git-oneline
print-git-oneline: $(PREFIX)/installed/print-git-oneline-$(GIT_HEAD)
$(PREFIX)/installed/print-git-oneline-$(GIT_HEAD): | $(PREFIX)/installed/.gitkeep
	@git log --pretty=tformat:'[git-log]   %h %s' -1 | cat
	@rm -f '$(PREFIX)/installed/print-git-oneline-'*
	@touch '$@'

# Common dependency lists for `make` prerequisites and `build-pkg`
#   - `make` considers only explicit normal deps to trigger rebuilds
#   - packages can add themselves to implicit MXE_REQS_PKGS in the case
#       of a tool like `patch` which may be outdated on some systems
#   - downloads and `build-pkg` use both explicit and implicit deps
#   - don't depend on `disabled` rules but do depend on virtual pkgs

# cross libraries depend on virtual toolchain package, variable used
# in `cleanup-deps-style` rule below
CROSS_COMPILER := cc

# set reqs and bootstrap variables to recursive so pkgs can add themselves
# CROSS_COMPILER depends (order-only) on MXE_REQS_PKGS
# all depend (order-only) on BOOTSTRAP_PKGS
# BOOTSTRAP_PKGS may be prefixed with $(BUILD)~
MXE_REQS_PKGS  =
BOOTSTRAP_PKGS =

# warning about switching from `gcc` to `cc`
$(if $(and $(filter gcc,$(LOCAL_PKG_LIST)$(MAKECMDGOALS)),\
           $(call seq,1,$(words $(LOCAL_PKG_LIST)$(MAKECMDGOALS)))),\
    $(info == gcc is now a dependency of virtual toolchain package cc) \
    $(info $(call repeat,$(space),6)- cc will build gcc, pkgconf, and other core toolchain packages)\
    $(info $(call repeat,$(space),6)- please update scripts accordingly (ignore if you are building gcc alone))\
    $(info ))

# distinguish between deliberately empty rules and disabled ones
# used in build-matrix
VIRTUAL_PKG_TYPES := source-only meta
# used in deps rules and build-pkg
BUILD_PKG_TYPES := meta
# used to avoid unpacking archives when $(PKG)_FILE can't be unset
SCRIPT_PKG_TYPES := script

# all pkgs have (implied) order-only dependencies on MXE_CONF_PKGS.
MXE_CONF_PKGS := mxe-conf

# dummy *.mk files (usually overrides for plugins)
NON_PKG_BASENAMES := overrides

# autotools/cmake are generally always required, but separate them
# for the case of `make gcc` which should only build real deps.
AUTOTOOLS_PKGS := $(filter-out $(MXE_CONF_PKGS) %autotools autoconf automake libtool, \
    $(sort $(basename $(notdir \
        $(shell grep -l 'auto[conf\|reconf\|gen\|make]\|aclocal\|LIBTOOL' \
                $(addsuffix /*.mk,$(MXE_PLUGIN_DIRS)))))))

CMAKE_PKGS := $(filter-out $(MXE_CONF_PKGS) cmake-conf cmake, \
    $(sort $(basename $(notdir \
        $(shell grep -l '(TARGET)-cmake' \
                $(addsuffix /*.mk,$(MXE_PLUGIN_DIRS)))))))

# all other packages should list their deps explicitly, if tools become
# universally used, we can add them to the toolchain deps (e.g. pkgconf)
# or add new implicit `${TOOL}_PKGS` rules

# $(PKG) and $(TARGET) are in scope from the calling loop so reference
# variables by name instead of position

# explicit normal package deps
PKG_DEPS = \
    $(foreach DEP,$(value $(call LOOKUP_PKG_RULE,$(PKG),DEPS,$(TARGET))), \
        $(if $(filter $(DEP),$(PKGS)), \
            $(if $(or $(value $(call LOOKUP_PKG_RULE,$(DEP),BUILD,$(TARGET))), \
                      $(filter $($(DEP)_TYPE),$(BUILD_PKG_TYPES))), \
                $(TARGET)/installed/$(DEP)) \
        $(else), \
            $(if $(or $(value $(call LOOKUP_PKG_RULE,$($(DEP)_PKG),BUILD,$($(DEP)_TGT))), \
                      $(filter $($($(DEP)_PKG)_TYPE),$(BUILD_PKG_TYPES))), \
                $($(DEP)_TGT)/installed/$($(DEP)_PKG))))

# order-only package deps - needs target lookup for e.g. zstd native case
PKG_OO_DEPS = \
    $(foreach DEP,$(value $(call LOOKUP_PKG_RULE,$(PKG),OO_DEPS,$(TARGET))), \
        $(if $(filter $(DEP),$(PKGS)), \
            $(if $(or $(value $(call LOOKUP_PKG_RULE,$(DEP),BUILD,$(TARGET))), \
                      $(filter $($(DEP)_TYPE),$(BUILD_PKG_TYPES))), \
                $(TARGET)/installed/$(DEP)) \
        $(else), \
            $(if $(or $(value $(call LOOKUP_PKG_RULE,$($(DEP)_PKG),BUILD,$($(DEP)_TGT))), \
                      $(filter $($($(DEP)_PKG)_TYPE),$(BUILD_PKG_TYPES))), \
                $($(DEP)_TGT)/installed/$($(DEP)_PKG))))

# all deps for download rules (includes source-only pkgs)
PKG_ALL_DEPS = \
    $(foreach DEP,$($(PKG)_OO_DEPS) $(value $(call LOOKUP_PKG_RULE,$(PKG),DEPS,$(TARGET))), \
        $(if $(filter $(DEP),$(PKGS)), \
            $(TARGET)~$(DEP), \
            $(DEP)))


# include files from MXE_PLUGIN_DIRS, set base filenames and `all-<plugin>` target
PLUGIN_FILES := $(realpath $(wildcard $(addsuffix /*.mk,$(MXE_PLUGIN_DIRS))))
PKGS         := $(sort $(filter-out $(NON_PKG_BASENAMES),$(basename $(notdir $(PLUGIN_FILES)))))
$(foreach FILE,$(PLUGIN_FILES),\
    $(if $(filter-out $(NON_PKG_BASENAMES),$(basename $(notdir $(FILE)))), \
        $(eval $(basename $(notdir $(FILE)))_MAKEFILE  ?= $(FILE)) \
        $(eval $(basename $(notdir $(FILE)))_TEST_FILE ?= $(filter-out %.cmake,$(wildcard $(basename $(FILE))-test.*))) \
        $(eval all-$(lastword $(call split,/,$(dir $(FILE)))): $(basename $(notdir $(FILE))))))
include $(PLUGIN_FILES)

# create target sets for PKG_TARGET_RULE loop to avoid creating empty rules
# and having to explicitly disable $(BUILD) for most packages
# add autotools, cmake, mxe-conf implicit order-only deps
CROSS_TARGETS := $(filter-out $(BUILD),$(MXE_TARGETS))
$(foreach PKG,$(PKGS), \
    $(if $(filter $(PKG),$(filter-out $(autotools_DEPS),$(AUTOTOOLS_PKGS))),\
        $(eval $(PKG)_OO_DEPS += $(BUILD)~autotools)) \
    $(if $(filter $(PKG),$(CMAKE_PKGS)),$(eval $(PKG)_OO_DEPS += cmake-conf)) \
    $(if $(filter $(PKG),$(MXE_CONF_PKGS)),,$(eval $(PKG)_OO_DEPS += mxe-conf)) \
    $(if $(filter %$(PKG),$(MXE_CONF_PKGS) $(BOOTSTRAP_PKGS)),,$(eval $(PKG)_OO_DEPS += $(BOOTSTRAP_PKGS))) \
    $(eval $(PKG)_TARGETS := $(sort $($(PKG)_TARGETS))) \
    $(if $($(PKG)_TARGETS),,$(eval $(PKG)_TARGETS := $(CROSS_TARGETS))) \
    $(foreach TARGET,$(filter $($(PKG)_TARGETS),$(CROSS_TARGETS) $(BUILD)), \
        $(eval $(TARGET)~$(PKG)_PKG := $(PKG)) \
        $(eval $(TARGET)~$(PKG)_TGT := $(TARGET)) \
        $(eval $(TARGET)_PKGS += $(PKG))))

# always add $(BUILD) to our targets
override MXE_TARGETS := $(CROSS_TARGETS) $(BUILD)

# cache some target string manipulation functions with normal make variables
CHOP_TARGETS = \
    $(if $(1),\
        $(eval CHOPPED := $(call merge,.,$(call chop,$(call split,.,$(1)))))\
        $(eval $(1)_CHOPPED := $(CHOPPED))\
        $(call CHOP_TARGETS,$(CHOPPED)))

$(foreach TARGET,$(MXE_TARGETS),\
    $(call CHOP_TARGETS,$(TARGET))\
    $(eval $(TARGET)_UC_LIB_TYPE := $(if $(findstring shared,$(TARGET)),SHARED,STATIC)))

# finds a package rule defintion
RULE_TYPES := BUILD DEPS FILE MESSAGE OO_DEPS URL
# by truncating the target elements then looking for STAIC|SHARED rules:
#
# foo_BUILD_i686-w64-mingw32.static.win32.dw2
# foo_BUILD_i686-w64-mingw32.static.win32
# foo_BUILD_i686-w64-mingw32.static
# foo_BUILD_i686-w64-mingw32
# foo_BUILD_SHARED
# foo_BUILD

# return the pre-populated rule if defined
LOOKUP_PKG_RULE = $(or $(LOOKUP_PKG_RULE_$(1)_$(2)_$(3)),$(1)_$(2))

# $(call _LOOKUP_PKG_RULE, package, rule type, target [, lib type])
# returns variable name for use with $(value). PKG_RULE below will
# populate LOOKUP_PKG_RULE_* variables for rules that require lookups
_LOOKUP_PKG_RULE = $(strip \
    $(if $(findstring undefined, $(flavor $(PKG)_$(RULE)_$(3))),\
        $(if $(3),\
            $(call _LOOKUP_PKG_RULE,$(PKG),$(RULE),$($(3)_CHOPPED),$(or $(4),$($(3)_UC_LIB_TYPE)))\
        $(else),\
            $(if $(4),\
                $(call _LOOKUP_PKG_RULE,$(PKG),$(RULE),$(4))\
            $(else),\
                $(PKG)_$(RULE)))\
    $(else),\
        $(PKG)_$(RULE)_$(3)))

# set column widths for build status messages
PKG_COL_WIDTH    := $(call plus,2,$(call LIST_NMAX, $(sort $(call map, strlen, $(PKGS)))))
MAX_TARGET_WIDTH := $(call LIST_NMAX, $(sort $(call map, strlen, $(MXE_TARGETS))))
TARGET_COL_WIDTH := $(call subtract,100,$(call plus,$(PKG_COL_WIDTH),$(MAX_TARGET_WIDTH)))
PRINTF_FMT       := printf '%-$(PRINTF_COL_1_WIDTH)s %-$(PKG_COL_WIDTH)s %-$(TARGET_COL_WIDTH)s %-15s %s\n'
RTRIM            := $(SED) 's, \+$$$$,,'
WRAP_MESSAGE      = $(\n)$(\n)$(call repeat,-,60)$(\n)$(1)$(and $(2),$(\n)$(\n)$(2))$(\n)$(call repeat,-,60)$(\n)

define TARGET_RULE
    $(if $(findstring i686-pc-mingw32,$(1)),\
        $(error $(call WRAP_MESSAGE,\
                Obsolete target specified: "$(1)",\
                Please use i686-w64-mingw32.[$(subst $(space),|,$(MXE_LIB_TYPES))]$(\n)\
                i686-pc-mingw32 removed 2014-10-14 (https://github.com/mxe/mxe/pull/529)\
                )))\
    $(if $(filter $(addsuffix %,$(MXE_TARGET_LIST) $(BUILD) $(MXE_TRIPLETS)),$(1)),,\
        $(error $(call WRAP_MESSAGE,\
                Invalid target specified: "$(1)",\
                Please use:$(\n)\
                $(subst $(space),$(\n) ,$(MXE_TARGET_LIST))\
                )))\
    $(if $(findstring 1,$(words $(subst ., ,$(filter-out $(BUILD),$(1))))),\
        $(warning $(call WRAP_MESSAGE,\
                Warning: Deprecated target specified "$(1)",\
                Please use $(1).[$(subst $(space),|,$(MXE_LIB_TYPES))]$(\n) \
                )))
endef
$(foreach TARGET,$(MXE_TARGETS),$(call TARGET_RULE,$(TARGET)))

define PKG_RULE
# configure GitHub metadata if GH_CONF is set
$(if $($(PKG)_GH_CONF),$(eval $(MXE_SETUP_GITHUB)))
$(eval $(PKG)_PATCHES := $(PKG_PATCHES))

.PHONY: download-only-$(1)
# Packages can share a source archive to build different sets of features
# or dependencies (see bfd/binutils openscenegraph/openthreads qwt/qwt_qt4).
# Use a double-colon rule to allow multiple definitions:
# https://www.gnu.org/software/make/manual/html_node/Double_002dColon.html
# N.B. the `::` rule will use values from first lexical definition e.g.:
# $ make download-only-binutils
# [download]  bfd
.PHONY: download-only-$($(1)_FILE)
download-only-$(1): download-only-$($(1)_FILE)
download-only-$($(1)_FILE)::
	$(and $($(1)_URL),
	@$$(if $$(REMOVE_DOWNLOAD),rm -f '$(PKG_DIR)/$($(1)_FILE)')
	@if ! $(call CHECK_PKG_ARCHIVE,$(1)); then \
	    $(PRINTF_FMT) '[download]' '$($(1)_FILE)' | $(RTRIM); \
	    [ -d '$(LOG_DIR)/$(TIMESTAMP)' ] || mkdir -p '$(LOG_DIR)/$(TIMESTAMP)'; \
	    ($(call DOWNLOAD_PKG_ARCHIVE,$(1))) &> '$(LOG_DIR)/$(TIMESTAMP)/$(1)-download'; \
	    grep 'MXE Warning' '$(LOG_DIR)/$(TIMESTAMP)/$(1)-download'; \
	    ln -sf '$(TIMESTAMP)/$(1)-download' '$(LOG_DIR)/$(1)-download'; \
	    if ! $(call CHECK_PKG_ARCHIVE,$(1)); then \
	        echo; \
	        echo 'Download failed or wrong checksum of package $(1)!'; \
	        echo '------------------------------------------------------------'; \
	        $(if $(findstring undefined, $(origin MXE_VERBOSE)),\
	            tail -n 10 '$(LOG_DIR)/$(1)-download' | $(SED) -n '/./p';, \
	            $(SED) -n '/./p' '$(LOG_DIR)/$(1)-download';) \
	        echo '------------------------------------------------------------'; \
	        echo '[log]      $(LOG_DIR)/$(1)-download'; \
	        echo; \
	        exit 1; \
	    fi; \
	fi)

.PHONY: prepare-pkg-source-$(1)
prepare-pkg-source-$(1): download-only-$(1)
	rm -rf '$(2)'
	mkdir -p '$(2)'
	$$(call PREPARE_PKG_SOURCE,$(1),$(2))

# populate LOOKUP_PKG_RULE_ variables where there are multiple defined
$(foreach RULE,$(RULE_TYPES),\
    $(if $(filter-out %_URL_2,$(filter-out $(PKG)_$(RULE),$(filter $(PKG)_$(RULE)%,$(.VARIABLES)))),\
        $(foreach TARGET,$(MXE_TARGETS),\
            $(eval LOOKUP_PKG_RULE_$(PKG)_$(RULE)_$(TARGET) := $(call _LOOKUP_PKG_RULE,$(PKG),$(RULE),$(TARGET))))))
endef
$(foreach PKG,$(PKGS),$(eval $(call PKG_RULE,$(PKG),$(call TMP_DIR,$(PKG)))))

# disable networking during build-only rules for reproducibility
ifeq ($(findstring darwin,$(BUILD)),)
    NONET_LIB := $(PREFIX)/$(BUILD)/lib/nonetwork.so
    PRELOAD   := LD_PRELOAD='$(NONET_LIB)'
else
    NONET_LIB := $(PREFIX)/$(BUILD)/lib/nonetwork.dylib
    PRELOAD   := DYLD_FORCE_FLAT_NAMESPACE=1 DYLD_INSERT_LIBRARIES='$(NONET_LIB)'
    NONET_CFLAGS := -arch x86_64
endif

$(NONET_LIB): $(TOP_DIR)/tools/nonetwork.c | $(PREFIX)/$(BUILD)/lib/.gitkeep
	@$(PRINTF_FMT) '[nonet lib]' '$@'
	+@$(BUILD_CC) -shared -fPIC $(NONET_CFLAGS) -o $@ $<

.PHONY: nonet-lib
nonet-lib: $(NONET_LIB)

.PHONY: shell
shell: $(NONET_LIB)
	$(PRELOAD) $(SHELL)

define PKG_TARGET_RULE
.PHONY: download-$(1)
download-$(1): download-$(3)~$(1) download-only-$(1)

.PHONY: download-$(3)~$(1)
download-$(3)~$(1): download-only-$(1) \
                    $(addprefix download-,$(PKG_ALL_DEPS))

.PHONY: $(1) $(1)~$(3)
# requested pkgs should not build their native version unless
# explicitly set in DEPS or they only have a single target
$(if $(filter-out $(BUILD),$(3))$(call not,$(word 2,$($(1)_TARGETS))),$(1)) \
    $(1)~$(3): $(PREFIX)/$(3)/installed/$(1)
$(PREFIX)/$(3)/installed/$(1): $(PKG_MAKEFILES) \
                          $($(PKG)_PATCHES) \
                          $(PKG_TESTFILES) \
                          $($(1)_FILE_DEPS) \
                          $(addprefix $(PREFIX)/,$(PKG_DEPS)) \
                          | $(if $(DONT_CHECK_REQUIREMENTS),,check-requirements) \
                          $(if $(value $(call LOOKUP_PKG_RULE,$(1),URL,$(3))),download-only-$(1)) \
                          $(addprefix $(PREFIX)/,$(PKG_OO_DEPS)) \
                          $(addprefix download-,$(PKG_ALL_DEPS)) \
                          $(NONET_LIB) \
                          $(PREFIX)/$(3)/installed/.gitkeep \
                          print-git-oneline
	$(if $(value $(call LOOKUP_PKG_RULE,$(1),MESSAGE,$(3))),
	    @$(PRINTF_FMT) '[message]'  '$(1)' '$(3) $($(call LOOKUP_PKG_RULE,$(1),MESSAGE,$(3)))' \
	    | $(RTRIM)
	)
	$(if $(value $(call LOOKUP_PKG_RULE,$(1),BUILD,$(3))),
	    $(if $(BUILD_DRY_RUN)$(MXE_BUILD_DRY_RUN), \
	        @$(PRINTF_FMT) '[dry-run]' '$(1)' '$(3)' | $(RTRIM)
	        @[ -d '$(PREFIX)/$(3)/lib' ] || mkdir -p '$(PREFIX)/$(3)/lib'
	        @echo $(1)~$(3) > '$(PREFIX)/$(3)/lib/$(1).dry-run'
	        @touch '$(PREFIX)/$(3)/installed/$(1)'
	    $(else),
	        @$(PRINTF_FMT) '[build]'    '$(1)' '$(3)' | $(RTRIM)
	        @[ -d '$(LOG_DIR)/$(TIMESTAMP)' ] || mkdir -p '$(LOG_DIR)/$(TIMESTAMP)'
	        @touch '$(LOG_DIR)/$(TIMESTAMP)/$(1)_$(3)'
	        @ln -sf '$(TIMESTAMP)/$(1)_$(3)' '$(LOG_DIR)/$(1)_$(3)'
	        @if ! (time $(PRELOAD) WINEPREFIX='$(2)/readonly' \
	               $(MAKE) -f '$(MAKEFILE)' \
	                   'build-only-$(1)_$(3)' \
	                   WGET=false \
	               ) &> '$(LOG_DIR)/$(TIMESTAMP)/$(1)_$(3)'; then \
	            echo; \
	            echo 'Failed to build package $(1) for target $(3)!'; \
	            echo '------------------------------------------------------------'; \
	            $(if $(findstring undefined, $(origin MXE_VERBOSE)),\
	                tail -n 10 '$(LOG_DIR)/$(1)_$(3)' | $(SED) -n '/./p';, \
	                $(SED) -n '/./p' '$(LOG_DIR)/$(1)_$(3)';) \
	            echo '------------------------------------------------------------'; \
	            echo '[log]      $(LOG_DIR)/$(1)_$(3)'; \
	            echo; \
	            exit 1; \
	        fi
	        @$(PRINTF_FMT) '[done]' '$(1)' '$(3)' "`grep -a '^du:.*KiB$$\' '$(LOG_DIR)/$(TIMESTAMP)/$(1)_$(3)' | cut -d ':' -f2 | tail -1`" \
	                                          "`grep -a '^real.*m.*s$$\' '$(LOG_DIR)/$(TIMESTAMP)/$(1)_$(3)' | tr '\t' ' ' | cut -d ' ' -f2 | tail -1`"
	    )
	$(else),
	    @$(PRINTF_FMT) '[$(or $($(PKG)_TYPE),disabled)]' '$(1)' '$(3)' | $(RTRIM)
	    @touch '$(PREFIX)/$(3)/installed/$(1)'
	)


.PHONY: build-only-$(1)_$(3)
# target-specific variables provide an extra level of scoping so that named
# variables can be used in package build rules:
# https://www.gnu.org/software/make/manual/html_node/Target_002dspecific.html
build-only-$(1)_$(3): PKG = $(1)
build-only-$(1)_$(3): TARGET = $(3)
build-only-$(1)_$(3): BUILD_$(if $(findstring shared,$(3)),SHARED,STATIC) = TRUE
build-only-$(1)_$(3): BUILD_$(if $(call seq,$(TARGET),$(BUILD)),NATIVE,CROSS) = TRUE
build-only-$(1)_$(3): $(if $(findstring win32,$(TARGET)),WIN32,POSIX)_THREADS = TRUE
build-only-$(1)_$(3): LIB_SUFFIX = $(if $(findstring shared,$(3)),dll,a)
build-only-$(1)_$(3): BITS = $(if $(findstring x86_64,$(3)),64,32)
build-only-$(1)_$(3): PROCESSOR = $(firstword $(call split,-,$(3)))
build-only-$(1)_$(3): BUILD_TYPE = $(if $(findstring debug,$(3) $($(1)_CONFIGURE_OPTS)),debug,release)
build-only-$(1)_$(3): BUILD_TYPE_SUFFIX = $(if $(findstring debug,$(3) $($(1)_CONFIGURE_OPTS)),d)
build-only-$(1)_$(3): INSTALL_STRIP_TOOLCHAIN = install$(if $(STRIP_TOOLCHAIN),-strip)
build-only-$(1)_$(3): INSTALL_STRIP_LIB = install$(if $(STRIP_LIB),-strip)
build-only-$(1)_$(3): SOURCE_DIR = $(or $(realpath $($(1)_SOURCE_TREE)),$(2)/$($(1)_SUBDIR))
build-only-$(1)_$(3): BUILD_DIR  = $(2)/$(if $($(1)_SOURCE_TREE),local,$($(1)_SUBDIR)).build_
build-only-$(1)_$(3): TEST_FILE  = $($(1)_TEST_FILE)
build-only-$(1)_$(3): CMAKE_RUNRESULT_FILE = $(PREFIX)/share/cmake/modules/TryRunResults.cmake
build-only-$(1)_$(3): CMAKE_TOOLCHAIN_FILE = $(PREFIX)/$(3)/share/cmake/mxe-conf.cmake
build-only-$(1)_$(3): CMAKE_TOOLCHAIN_DIR  = $(PREFIX)/$(3)/share/cmake/mxe-conf.d
build-only-$(1)_$(3): CMAKE_STATIC_BOOL = $(if $(findstring shared,$(3)),OFF,ON)
build-only-$(1)_$(3): CMAKE_SHARED_BOOL = $(if $(findstring shared,$(3)),ON,OFF)
build-only-$(1)_$(3):
	$(if $(value $(call LOOKUP_PKG_RULE,$(1),BUILD,$(3))),
	    uname -a
	    - git log --pretty=tformat:"%H - %s [%ar] [%d]" -1
	    lsb_release -a 2>/dev/null || sw_vers 2>/dev/null || true
	    autoconf --version 2>/dev/null | head -1
	    automake --version 2>/dev/null | head -1
	    $(BUILD_CC) --version
	    $(BUILD_CXX) --version
	    python --version
	    perl --version 2>&1 | head -3
	    rm -rf   '$(2)'
	    mkdir -p '$(2)'
	    mkdir -p '$$(SOURCE_DIR)'
	    mkdir -p '$$(BUILD_DIR)'

	    # disable wine with readonly directory
	    # see https://github.com/mxe/mxe/issues/841
	    mkdir -p '$(2)/readonly'
	    chmod 0555 '$(2)/readonly'

	    $$(if $(and $(value $(call LOOKUP_PKG_RULE,$(1),FILE,$(3))),\
	                $(call not,$(filter $(SCRIPT_PKG_TYPES),$($(PKG)_TYPE)))),\
	        $$(call PREPARE_PKG_SOURCE,$(1),$(2)))
	    $$(call $(call LOOKUP_PKG_RULE,$(1),BUILD,$(3)),$(2)/$($(1)_SUBDIR))
	    @echo
	    @find '$(2)' -name 'config.log' -print -exec cat {} \;
	    @echo
	    @echo 'settings.mk'
	    @cat '$(TOP_DIR)/settings.mk'
	    $(if $(STRIP_EXE),-$(TARGET)-strip '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe')
	    (du -k -d 0 '$(2)' 2>/dev/null || du -k --max-depth 0 '$(2)') | $(SED) -n 's/^\(\S*\).*/du: \1 KiB/p'
	    rm -rfv  '$(2)'
	    )
	touch '$(PREFIX)/$(3)/installed/$(1)'
endef
$(foreach TARGET,$(MXE_TARGETS), \
    $(foreach PKG,$($(TARGET)_PKGS), \
        $(eval $(call PKG_TARGET_RULE,$(PKG),$(call TMP_DIR,$(PKG)-$(TARGET)),$(TARGET)))))

# convenience set-like functions for unique lists
SET_APPEND = \
    $(eval $(1) := $(sort $($(1)) $(2)))

SET_CLEAR = \
    $(eval $(1) := )

# WALK functions accept a list of pkgs and/or wildcards
# use PKG_ALL_DEPS and strip target prefixes to get
# global package level deps
WALK_UPSTREAM = \
    $(strip \
        $(foreach PKG,$(filter $(1),$(PKGS)),\
          $(foreach TARGET,$($(PKG)_TARGETS), \
            $(foreach DEP,$(sort $(subst $(BUILD)~,,$(subst $(TARGET)~,,$(PKG_ALL_DEPS)))),\
              $(if $(filter-out $(PKGS_VISITED),$(DEP)),\
                  $(call SET_APPEND,PKGS_VISITED,$(DEP))\
                  $(call WALK_UPSTREAM,$(DEP))\
                  $(DEP))))))

# not really walking downstream - that seems to be quadratic, so take
# a linear approach and filter the fully expanded upstream for each pkg
WALK_DOWNSTREAM = \
    $(strip \
        $(foreach PKG,$(PKGS),\
            $(call SET_CLEAR,PKGS_VISITED)\
            $(eval ALL_$(PKG)_DEPS := $(call WALK_UPSTREAM,$(PKG))))\
        $(foreach PKG,$(PKGS),\
            $(if $(filter $(1),$(ALL_$(PKG)_DEPS)),$(PKG))))

# list of direct downstream deps
DIRECT_DOWNSTREAM = \
    $(strip \
        $(foreach PKG,$(PKGS),\
            $(if $(filter $(1),$($(PKG)_DEPS)),$(PKG))))

# EXCLUDE_PKGS can be a list of pkgs and/or wildcards
RECURSIVELY_EXCLUDED_PKGS = \
    $(sort \
        $(filter $(EXCLUDE_PKGS),$(PKGS))\
        $(call SET_CLEAR,PKGS_VISITED)\
        $(call WALK_DOWNSTREAM,$(EXCLUDE_PKGS)))

# INCLUDE_PKGS can be a list of pkgs and/or wildcards
# only used by build-pkg
INCLUDE_PKGS := $(MXE_BUILD_PKG_PKGS)
RECURSIVELY_INCLUDED_PKGS = \
    $(sort \
        $(filter $(INCLUDE_PKGS),$(PKGS))\
        $(call SET_CLEAR,PKGS_VISITED)\
        $(call WALK_UPSTREAM,$(INCLUDE_PKGS)))

REQUIRED_PKGS = \
    $(filter-out $(and $(EXCLUDE_PKGS),$(RECURSIVELY_EXCLUDED_PKGS)),\
      $(or $(and $(INCLUDE_PKGS),$(strip $(RECURSIVELY_INCLUDED_PKGS))),$(PKGS)))

.PHONY: all-filtered
all-filtered: $(REQUIRED_PKGS)

.PHONY: download
download: $(addprefix download-,$(REQUIRED_PKGS))

# print a list of upstream dependencies and downstream dependents
show-deps-%:
	$(if $(call set_is_member,$*,$(PKGS)),\
	    $(call SET_CLEAR,PKGS_VISITED)\
	    $(info $* upstream dependencies:$(newline)\
	        $(call WALK_UPSTREAM,$*)\
	        $(newline)$(newline)$* direct downstream dependents:$(newline)\
	        $(call DIRECT_DOWNSTREAM,$*)\
	        $(newline)$(newline)$* recursive downstream dependents:$(newline)\
	        $(call WALK_DOWNSTREAM,$*))\
	    @echo,\
	    $(error Package $* not found))

# show upstream dependencies and downstream dependents separately
# suitable for usage in shell with: `make show-downstream-deps-foo`
# @echo -n suppresses the "Nothing to be done" without an eol
show-downstream-deps-%:
	$(if $(call set_is_member,$*,$(PKGS)),\
	    $(call SET_CLEAR,PKGS_VISITED)\
	    $(info $(call WALK_DOWNSTREAM,$*))\
	    @echo -n,\
	    $(error Package $* not found))

show-direct-downstream-deps-%:
	$(if $(call set_is_member,$*,$(PKGS)),\
	    $(info $(call DIRECT_DOWNSTREAM,$*))\
	    @echo -n,\
	    $(error Package $* not found))

show-upstream-deps-%:
	$(if $(call set_is_member,$*,$(PKGS)),\
	    $(call SET_CLEAR,PKGS_VISITED)\
	    $(info $(call WALK_UPSTREAM,$*))\
	    @echo -n,\
	    $(error Package $* not found))

# print first level pkg deps for use in build-pkg.lua
.PHONY: print-deps-for-build-pkg
print-deps-for-build-pkg:
	$(foreach TARGET,$(sort $(MXE_TARGETS)), \
	    $(foreach PKG,$(filter $(REQUIRED_PKGS),$(sort $($(TARGET)_PKGS))), \
	        $(if $(or $(value $(call LOOKUP_PKG_RULE,$(PKG),BUILD,$(TARGET))), \
	                  $(filter $($(PKG)_TYPE),$(BUILD_PKG_TYPES))), \
	            $(info $(strip for-build-pkg $(TARGET)~$(PKG) \
	            $(subst $(space),-,$($(PKG)_VERSION)-$(OS_SHORT_NAME)) \
	            $(subst /installed/,~,$(PKG_DEPS) $(PKG_OO_DEPS)))))))
	            @echo -n

BUILD_PKG_TMP_FILES := *-*.list mxe-*.tar.xz mxe-*.deb* wheezy jessie

.PHONY: clean
clean:
	rm -rf $(call TMP_DIR,*) $(PREFIX) \
	       $(addprefix $(TOP_DIR)/, $(BUILD_PKG_TMP_FILES))
	@echo
	@echo 'review ccache size with:'
	@echo '$(MXE_CCACHE_DIR)/bin/ccache -s'

.PHONY: clean-pkg
clean-pkg:
	rm -f $(patsubst %,'%', \
                  $(filter-out \
                      $(foreach PKG,$(PKGS),$(PKG_DIR)/$($(PKG)_FILE) $(PKG_DIR)/$($(PKG)_FILE)_$($(PKG)_CHECKSUM)), \
                      $(wildcard $(PKG_DIR)/*)))

.PHONY: clean-junk
clean-junk: clean-pkg
	rm -rf $(LOG_DIR) $(call TMP_DIR,*)

.PHONY: cleanup-style
define CLEANUP_STYLE
    @$(SED) ' \
        s/\r//g; \
        s/[ \t]\+$$//; \
        s,^#!/bin/bash$$,#!/usr/bin/env bash,; \
        $(if $(filter %Makefile,$(1)),,\
            s/\t/    /g; \
        ) \
    ' < $(1) > $(TOP_DIR)/tmp-cleanup-style
    @diff -u $(1) $(TOP_DIR)/tmp-cleanup-style >/dev/null \
        || { echo '[cleanup] $(1)'; \
             cp $(TOP_DIR)/tmp-cleanup-style $(1); }
    @rm -f $(TOP_DIR)/tmp-cleanup-style

endef
cleanup-style:
	$(foreach FILE,$(wildcard $(addprefix $(TOP_DIR)/,Makefile docs/index.html docs/CNAME src/*.mk src/*test.* tools/*)),$(call CLEANUP_STYLE,$(FILE)))

.PHONY: cleanup-deps-style
cleanup-deps-style:
	@grep '(PKG)_DEPS.*\\' $(foreach 1,$(PKGS),$(PKG_MAKEFILES)) > $(TOP_DIR)/tmp-$@-pre
	@$(foreach PKG,$(PKGS), \
	    $(if $(call lne,$(sort $(filter-out $(CROSS_COMPILER),$($(PKG)_DEPS))),$(filter-out $(CROSS_COMPILER),$($(PKG)_DEPS))), \
	        $(info [cleanup] $(PKG)) \
	        $(SED) -i 's/^\([^ ]*_DEPS *:=\)[^$$]*$$/\1 '"$(strip $(filter $(CROSS_COMPILER),$($(PKG)_DEPS)) $(sort $(filter-out $(CROSS_COMPILER),$($(PKG)_DEPS))))"'/' '$(call PKG_MAKEFILES,$(PKG))'; \
	    ))
	@grep '(PKG)_DEPS.*\\' $(foreach 1,$(PKGS),$(PKG_MAKEFILES)) > $(TOP_DIR)/tmp-$@-post
	@diff -u $(TOP_DIR)/tmp-$@-pre $(TOP_DIR)/tmp-$@-post >/dev/null \
	     || echo '*** Multi-line deps are mangled ***' && comm -3 tmp-$@-pre tmp-$@-post
	@rm -f $(TOP_DIR)/tmp-$@-*

.PHONY: docs/build-matrix.html
docs/build-matrix.html: $(foreach 1,$(PKGS),$(PKG_MAKEFILES))
	@echo '<!DOCTYPE html>'                  > $@
	@echo '<html>'                          >> $@
	@echo '<head>'                          >> $@
	@echo '<meta http-equiv="content-type" content="text/html; charset=utf-8">' >> $@
	@echo '<title>MXE Build Matrix</title>' >> $@
	@echo '<link rel="stylesheet" href="assets/common.css">'       >> $@
	@echo '<link rel="stylesheet" href="assets/build-matrix.css">' >> $@
	@echo '</head>'                         >> $@
	@echo '<body>'                          >> $@
	@echo '<h2>MXE Build Matrix</h2>'       >> $@
	@echo '<p>'                             >> $@
	@echo 'This is a table of all supported package/target'        >> $@
	@echo 'matrix. Being supported means that this specific'       >> $@
	@echo 'combination is working to the best of our knowledge,'   >> $@
	@echo 'but does not mean that it is tested daily.'             >> $@
	@echo '</p>'                            >> $@
	@echo '<p>'                             >> $@
	@echo 'If you found that some package is not working properly,'>> $@
	@echo 'please file a ticket on GitHub. If you figured out a'   >> $@
	@echo 'way to make the package work for unsupported targets,'  >> $@
	@echo 'feel free to submit a pull request.'                    >> $@
	@echo '</p>'                            >> $@
	@echo '<table class="fullscreen">'      >> $@
	@echo '<thead>'                         >> $@
	@echo '<tr>'                            >> $@
	@echo '<th rowspan="2">Package</th>'    >> $@
	@echo '<th rowspan="2">Version</th>'    >> $@
	@$(foreach TRIPLET,$(MXE_TRIPLETS),          \
	    echo '<th colspan="$(words $(MXE_LIB_TYPES))">$(TRIPLET)</th>' >> $@;)
	@echo '<th rowspan="2">Native</th>'     >> $@
	@echo '</tr>'                           >> $@
	@echo '<tr>'                            >> $@
	@$(foreach TRIPLET,$(MXE_TRIPLETS),          \
	    $(foreach LIB, $(MXE_LIB_TYPES),         \
	        echo '<th>$(LIB)</th>'          >> $@;))
	@echo '</tr>'                           >> $@
	@echo '</thead>'                        >> $@
	@echo '<tbody>'                         >> $@
# It is important to remember that the PKGCOUNT variables
# are expressed in unary terms. So, after 5 virtual packages,
# the content of $(VIRTUAL_PKGCOUNT) would be "x x x x x" and not "5".
# Therefore, when using the PKGCOUNT, you have to use
#     $(words $(VIRTUAL_PKGCOUNT))

# The same operations are included in GMSL "Integer Arithmetic Functions."
# I chose not to use most of them because their names are too long.
#     $(eval $(VIRTUAL_PKGCOUNT += x))
# vs
#     $(eval $(VIRTUAL_PKGCOUNT := $(call int_inc,$(VIRTUAL_PKGCOUNT))))
	@$(foreach PKG,$(PKGS), \
	    $(eval $(PKG)_VIRTUAL := $(true)) \
	    $(eval $(PKG)_BUILD_ONLY := $(true)) \
	    echo -e '<tr>\n \
	        <th class="row" \
	            title="$($(PKG)_MESSAGE)"> \
	            $(PKG) \
	            $(if $($(PKG)_TYPE), [$($(PKG)_TYPE)-pkg]) \
	            $(if $($(PKG)_MESSAGE), **)\
	        </th>\n \
	        <td>$(call substr,$($(PKG)_VERSION),1,12) \
	            $(if $(call gt,$(call strlen,$($(PKG)_VERSION)),12),&hellip;)</td>\n\
	    $(foreach TARGET,$(MXE_TARGET_LIST), \
	        $(if $(filter $(VIRTUAL_PKG_TYPES),$($(PKG)_TYPE)), \
	            $(if $(filter $(TARGET),$($(PKG)_TARGETS)), \
	                <td class="neutral">&bull;</td>, \
	                <td></td>), \
	            $(if $(filter $(TARGET),$($(PKG)_TARGETS)), \
	                $(if $(value $(call LOOKUP_PKG_RULE,$(PKG),BUILD,$(TARGET))), \
	                    $(eval $(TARGET)_PKGCOUNT += x) \
	                    <td class="supported">&#x2713;</td>, \
	                    <td class="unsupported">&#215;</td>),\
	                	<td></td>))\n) \
	    $(if $(filter $(VIRTUAL_PKG_TYPES),$($(PKG)_TYPE)), \
	        $(eval VIRTUAL_PKGCOUNT += x) \
	        $(if $(filter $(BUILD),$($(PKG)_TARGETS)), \
	            <td class="neutral">&bull;</td>, \
	            <td></td>), \
	        $(if $(filter $(BUILD),$($(PKG)_TARGETS)), \
	            $(if $(value $(call LOOKUP_PKG_RULE,$(PKG),BUILD,$(BUILD))), \
	                <td class="supported">&#x2713;</td>, \
	                <td class="unsupported">&#215;</td>), \
	                <td></td>))\n \
	        </tr>\n' >> $@ $(newline) \
	    $(if $(call seq,$(BUILD),$($(PKG)_TARGETS)), \
	        $(eval BUILD_ONLY_PKGCOUNT += x)))
	@echo '<tr>'                            >> $@
	@echo '<th class="row" colspan="2">'    >> $@
# TOTAL_PKGCOUNT = PKGS - (VIRTUAL + BUILD_ONLY)
	@echo 'Total: $(call subtract,               \
	                  $(words $(PKGS)),          \
	                  $(words $(VIRTUAL_PKGCOUNT) $(BUILD_ONLY_PKGCOUNT)))'\
	                                        >> $@
	@echo '<br>(+$(words $(VIRTUAL_PKGCOUNT)) virtual' >> $@
	@echo '+$(words $(BUILD_ONLY_PKGCOUNT)) native-only)' >> $@
	@echo '</th>'                           >> $@
	@$(foreach TARGET,$(MXE_TARGET_LIST),        \
	    echo '<th>$(words $($(TARGET)_PKGCOUNT))</th>' >> $@;)
	@echo '<th>$(words $($(BUILD)_PKGS))</th>' >> $@
	@echo '</tr>'                           >> $@
	@echo '</tbody>'                        >> $@
	@echo '</table>'                        >> $@
	@echo '</body>'                         >> $@
	@echo '</html>'                         >> $@

.PHONY: docs/packages.json
docs/packages.json: $(foreach 1,$(PKGS),$(PKG_MAKEFILES))
	@echo '{'                         > $@
	@{$(foreach PKG,$(PKGS),          \
	    echo '    "$(PKG)":           \
	        {"version": "$($(PKG)_VERSION)", \
	         "website": "$($(PKG)_WEBSITE)", \
	         "description": "$($(PKG)_DESCR)"},';)} >> $@
	@echo '    "": null'             >> $@
	@echo '}'                        >> $@

# for other mxe functions
include mxe.patch.mk
include mxe.updates.mk
