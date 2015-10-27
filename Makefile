# This file is part of MXE.
# See index.html for further information.

MAKEFILE := $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
TOP_DIR  := $(patsubst %/,%,$(dir $(MAKEFILE)))
EXT_DIR  := $(TOP_DIR)/ext

# GNU Make Standard Library (http://gmsl.sourceforge.net/)
# See doc/gmsl.html for further information
include $(EXT_DIR)/gmsl

MXE_TRIPLETS       := i686-w64-mingw32 x86_64-w64-mingw32
MXE_LIB_TYPES      := static shared
MXE_TARGET_LIST    := $(foreach TRIPLET,$(MXE_TRIPLETS),\
                          $(addprefix $(TRIPLET).,$(MXE_LIB_TYPES)))
MXE_TARGETS        := i686-w64-mingw32.static

DEFAULT_MAX_JOBS   := 6
SOURCEFORGE_MIRROR := downloads.sourceforge.net
PKG_MIRROR         := s3.amazonaws.com/mxe-pkg
PKG_CDN            := d1yihgixbnrglp.cloudfront.net

PWD        := $(shell pwd)
SHELL      := bash

MXE_TMP := $(PWD)

BUILD_CC   := $(shell (gcc --help >/dev/null 2>&1 && echo gcc) || (clang --help >/dev/null 2>&1 && echo clang))
BUILD_CXX  := $(shell (g++ --help >/dev/null 2>&1 && echo g++) || (clang++ --help >/dev/null 2>&1 && echo clang++))
DATE       := $(shell gdate --help >/dev/null 2>&1 && echo g)date
INSTALL    := $(shell ginstall --help >/dev/null 2>&1 && echo g)install
LIBTOOL    := $(shell glibtool --help >/dev/null 2>&1 && echo g)libtool
LIBTOOLIZE := $(shell glibtoolize --help >/dev/null 2>&1 && echo g)libtoolize
PATCH      := $(shell gpatch --help >/dev/null 2>&1 && echo g)patch
SED        := $(shell gsed --help >/dev/null 2>&1 && echo g)sed
SORT       := $(shell gsort --help >/dev/null 2>&1 && echo g)sort
WGET       := wget --no-check-certificate \
                   --user-agent=$(shell wget --version | \
                   $(SED) -n 's,GNU \(Wget\) \([0-9.]*\).*,\1/\2,p')

REQUIREMENTS := autoconf automake autopoint bash bison bzip2 cmake flex \
                $(BUILD_CC) $(BUILD_CXX) gperf intltoolize $(LIBTOOL) \
                $(LIBTOOLIZE) $(MAKE) openssl $(PATCH) $(PERL) python \
                ruby scons $(SED) $(SORT) unzip wget xz 7za gdk-pixbuf-csource

PREFIX     := $(PWD)/usr
LOG_DIR    := $(PWD)/log
TIMESTAMP  := $(shell date +%Y%m%d_%H%M%S)
PKG_DIR    := $(PWD)/pkg
TMP_DIR     = $(MXE_TMP)/tmp-$(1)
PKGS       := $(call set_create,\
    $(shell $(SED) -n 's/^.* class="package">\([^<]*\)<.*$$/\1/p' '$(TOP_DIR)/index.html'))
BUILD      := $(shell '$(EXT_DIR)/config.guess')
PATH       := $(PREFIX)/$(BUILD)/bin:$(PREFIX)/bin:$(PATH)

# All pkgs have (implied) order-only dependencies on MXE_CONF_PKGS.
# These aren't meaningful to the pkg list in index.html so
# use a list in case we want to separate autotools, cmake etc.
MXE_CONF_PKGS := mxe-conf
PKGS          += $(MXE_CONF_PKGS)

# define some whitespace variables
define newline


endef

null  :=
space := $(null) $(null)

MXE_CONFIGURE_OPTS = \
    --host='$(TARGET)' \
    --build='$(BUILD)' \
    --prefix='$(PREFIX)/$(TARGET)' \
    $(if $(BUILD_STATIC), \
        --enable-static --disable-shared , \
        --disable-static --enable-shared )

# Append these to the "make" and "make install" steps of autotools packages
# in order to neither build nor install unwanted binaries, manpages,
# infopages and API documentation (reduces build time and disk space usage).
# NOTE: We don't include bin_SCRIPTS (and variations), since many packages
# install files such as pcre-config (which we do want to be installed).

MXE_DISABLE_PROGRAMS = \
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
    notrans_dist_man_MANS= \
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

define MXE_GET_GITHUB_SHA
    $(WGET) -q -O- 'https://api.github.com/repos/$(strip $(1))/git/refs/heads/$(strip $(2))' \
    | $(SED) -n 's#.*"sha": "\([^"]\{10\}\).*#\1#p' \
    | head -1
endef

define MXE_GET_GITHUB_TAGS
    $(WGET) -q -O- 'https://api.github.com/repos/$(strip $(1))/git/refs/tags/' \
    | $(SED) -n 's#.*"ref": "refs/tags/\([^"]*\).*#\1#p' \
    | $(SORT) -V \
    | tail -1
endef

# use a minimal whitelist of safe environment variables
ENV_WHITELIST := PATH LANG MAKE% MXE% %PROXY %proxy LD_LIBRARY_PATH ACLOCAL_PATH
unexport $(filter-out $(ENV_WHITELIST),$(shell env | cut -d '=' -f1))

# disable wine with readonly directory (created by mxe-conf)
# see https://github.com/mxe/mxe/issues/841
export WINEPREFIX=$(PREFIX)/readonly

SHORT_PKG_VERSION = \
    $(word 1,$(subst ., ,$($(1)_VERSION))).$(word 2,$(subst ., ,$($(1)_VERSION)))

UNPACK_ARCHIVE = \
    $(if $(filter %.tgz,     $(1)),tar xzf '$(1)', \
    $(if $(filter %.tar.gz,  $(1)),tar xzf '$(1)', \
    $(if $(filter %.tbz2,    $(1)),tar xjf '$(1)', \
    $(if $(filter %.tar.bz2, $(1)),tar xjf '$(1)', \
    $(if $(filter %.tar.lzma,$(1)),xz -dc -F lzma '$(1)' | tar xf -, \
    $(if $(filter %.txz,     $(1)),xz -dc '$(1)' | tar xf -, \
    $(if $(filter %.tar.xz,  $(1)),xz -dc '$(1)' | tar xf -, \
    $(if $(filter %.7z,      $(1)),7za x '$(1)', \
    $(if $(filter %.zip,     $(1)),unzip -q '$(1)', \
    $(error Unknown archive format: $(1)))))))))))

UNPACK_PKG_ARCHIVE = \
    $(call UNPACK_ARCHIVE,$(PKG_DIR)/$($(1)_FILE))

PATCHES = $(sort $(wildcard $(TOP_DIR)/src/$(1)-[0-9]*.patch))

define PREPARE_PKG_SOURCE
    cd '$(2)' && $(call UNPACK_PKG_ARCHIVE,$(1))
    cd '$(2)/$($(1)_SUBDIR)'
    $(foreach PKG_PATCH,$(PATCHES),
        (cd '$(2)/$($(1)_SUBDIR)' && $(PATCH) -p1 -u) < $(PKG_PATCH))
endef

PKG_CHECKSUM = \
    openssl sha256 '$(PKG_DIR)/$($(1)_FILE)' 2>/dev/null | $(SED) -n 's,^.*\([0-9a-f]\{64\}\)$$,\1,p'

CHECK_PKG_ARCHIVE = \
    [ '$($(1)_CHECKSUM)' == "`$$(call PKG_CHECKSUM,$(1))`" ]

ESCAPE_PKG = \
	echo '$($(1)_FILE)' | perl -lpe 's/([^A-Za-z0-9])/sprintf("%%%02X", ord($$$$1))/seg'

BACKUP_DOWNLOAD = \
    (echo "MXE Warning! Downloading $(1) from backup." >&2 && \
    ($(WGET) -O- $(PKG_MIRROR)/`$(call ESCAPE_PKG,$(1))` || \
    $(WGET) -O- $(PKG_CDN)/`$(call ESCAPE_PKG,$(1))`))

DOWNLOAD_PKG_ARCHIVE = \
        mkdir -p '$(PKG_DIR)' && ( \
            $(WGET) -T 30 -t 3 -O- '$($(1)_URL)' \
            $(if $($(1)_URL_2), \
                || (echo "MXE Warning! Downloading $(1) from second URL." >&2 && \
                    $(WGET) -T 30 -t 3 -O- '$($(1)_URL_2)')) \
            $(if $(MXE_NO_BACKUP_DL),, \
                || $(BACKUP_DOWNLOAD)) \
        ) \
        $(if $($(1)_FIX_GZIP), \
            | gzip -d | gzip -9n, \
            ) \
        > '$(PKG_DIR)/$($(1)_FILE)' || \
        ( echo; \
          echo 'Download failed!'; \
          echo; \
          rm -f '$(PKG_DIR)/$($(1)_FILE)'; )

ifneq ($(words $(PWD)),1)
    $(error GNU Make chokes on paths with spaces)
endif

ifeq ($(IGNORE_SETTINGS),yes)
    $(info [ignore settings.mk])
else ifeq ($(wildcard $(PWD)/settings.mk),$(PWD)/settings.mk)
    include $(PWD)/settings.mk
else
    $(info [create settings.mk])
    $(shell { \
        echo '# This is a template of configuration file for MXE. See'; \
        echo '# index.html for more extensive documentations.'; \
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
        echo '# This variable controls the download mirror for SourceForge,'; \
        echo '# when it is used. Enabling the value below means auto.'; \
        echo '#SOURCEFORGE_MIRROR := downloads.sourceforge.net'; \
        echo; \
        echo '# The three lines below makes `make` build these "local'; \
        echo '# packages" instead of all packages.'; \
        echo '#LOCAL_PKG_LIST := boost curl file flac lzo pthreads vorbis wxwidgets'; \
        echo '#.DEFAULT local-pkg-list:'; \
        echo '#local-pkg-list: $$(LOCAL_PKG_LIST)'; \
    } >'$(PWD)/settings.mk')
endif

# Numeric min and max list functions
LIST_NMAX   = $(shell echo '$(strip $(1))' | tr ' ' '\n' | sort -n | tail -1)
LIST_NMIN   = $(shell echo '$(strip $(1))' | tr ' ' '\n' | sort -n | head -1)

NPROCS     := $(shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)
JOBS_AUTO  := $(call LIST_NMIN, $(DEFAULT_MAX_JOBS) $(NPROCS))
JOBS       := $(strip $(if $(findstring undefined,$(origin JOBS)),\
                   $(if $(and $(MAKECMDGOALS),$(filter $(MAKECMDGOALS),$(PKGS))), \
                       $(info [using autodetected $(JOBS_AUTO) job(s)])) \
                   $(JOBS_AUTO)\
              ,\
                   $(JOBS)))

# cache some target string manipulation functions
# `memoize` and `uc` from gmsl
_CHOP_TARGET = $(call merge,.,$(call chop,$(call split,.,$(1))))
CHOP_TARGET  = $(call memoize,_CHOP_TARGET,$(1))
_UC_LIB_TYPE = $(call uc,$(word 2,$(subst ., ,$(1))))
UC_LIB_TYPE  = $(call memoize,_UC_LIB_TYPE,$(1))

# finds a package build rule or deps by truncating the target elements
# $(call LOOKUP_PKG_RULE, package, rule type ie. BUILD|DEPS|FILE, target,[lib type, original target to cache])
# returns variable name for use with $(value)
#
# caches result with gmsl associative arrays (`get` and `set` functions)
# since `memoize` only works with single argument
LOOKUP_PKG_RULE = $(strip \
    $(or $(call get,LOOKUP_PKG_RULE_,$(1)_$(2)_$(or $(5),$(3))),\
    $(if $(findstring undefined, $(flavor $(1)_$(2)_$(3))),\
        $(if $(3),\
            $(call LOOKUP_PKG_RULE,$(1),$(2),$(call CHOP_TARGET,$(3)),$(or $(4),$(call UC_LIB_TYPE,$(3))),$(or $(5),$(3))),\
            $(if $(4),\
                $(call LOOKUP_PKG_RULE,$(1),$(2),$(4),,$(5)),\
                $(call set,LOOKUP_PKG_RULE_,$(1)_$(2)_$(5),$(1)_$(2))\
                $(1)_$(2))),\
        $(call set,LOOKUP_PKG_RULE_,$(1)_$(2)_$(or $(5),$(3)),$(1)_$(2)_$(3))\
        $(1)_$(2)_$(3))))

.PHONY: all
all: all-filtered

.PHONY: check-requirements
define CHECK_REQUIREMENT
    @if ! $(1) --help &>/dev/null; then \
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
$(shell [ -d '$(PREFIX)/installed' ] || mkdir -p '$(PREFIX)/installed')

check-requirements: $(PREFIX)/installed/check-requirements
$(PREFIX)/installed/check-requirements: $(MAKEFILE)
	@echo '[check requirements]'
	$(foreach REQUIREMENT,$(REQUIREMENTS),$(call CHECK_REQUIREMENT,$(REQUIREMENT)))
	$(call CHECK_REQUIREMENT_VERSION,autoconf,2\.6[7-9]\|2\.[7-9][0-9])
	$(call CHECK_REQUIREMENT_VERSION,automake,1\.11\.[3-9]\|1\.[1-9][2-9]\(\.[0-9]\+\)\?)
	@if [ -e check-requirements-failed ]; then \
	    echo; \
	    echo 'Please have a look at "index.html" to ensure'; \
	    echo 'that your system meets all requirements.'; \
	    echo; \
	    rm check-requirements-failed; \
	    exit 1; \
	fi
	@touch '$@'

include $(patsubst %,$(TOP_DIR)/src/%.mk,$(PKGS))

BUILD_PKGS := $(call set_create, \
    $(foreach PKG, \
        $(shell grep -l 'BUILD_$$(BUILD)' '$(TOP_DIR)/src/'*.mk | \
            $(SED) -n 's,.*src/\(.*\)\.mk,\1,p'), \
        $(if $(value $(call LOOKUP_PKG_RULE,$(PKG),BUILD,$(BUILD))), $(PKG))))

# create target sets for PKG_TARGET_RULE loop to avoid creating empty rules
# and having to explicitly disable $(BUILD) for most packages
CROSS_TARGETS := $(filter-out $(BUILD),$(MXE_TARGETS))
$(foreach PKG,$(PKGS), \
    $(foreach TARGET,$(or $(sort $($(PKG)_TARGETS)),$(CROSS_TARGETS)), \
        $(eval $(TARGET)_PKGS += $(PKG)) \
        $(eval FILTERED_PKGS  += $(PKG))))

# cross targets depend on native target
$(foreach TARGET,$(CROSS_TARGETS),\
    $(eval $(TARGET)_DEPS = $(BUILD)))

# always add $(BUILD) to our targets
override MXE_TARGETS := $(CROSS_TARGETS) $(BUILD)

# set column widths for build status messages
PKG_COL_WIDTH    := $(call plus,2,$(call LIST_NMAX, $(sort $(call map, strlen, $(PKGS)))))
MAX_TARGET_WIDTH := $(call LIST_NMAX, $(sort $(call map, strlen, $(MXE_TARGETS))))
TARGET_COL_WIDTH := $(call subtract,100,$(call plus,$(PKG_COL_WIDTH),$(MAX_TARGET_WIDTH)))
PRINTF_FMT       := printf '%-11s %-$(PKG_COL_WIDTH)s %-$(TARGET_COL_WIDTH)s %-15s %s\n'

.PHONY: download
download: $(addprefix download-,$(PKGS))

.PHONY: build-requirements
build-requirements:
	@$(MAKE) -f '$(MAKEFILE)' $(BUILD_PKGS) MXE_TARGETS=$(BUILD) DONT_CHECK_REQUIREMENTS=true

define TARGET_RULE
	$(if $(findstring i686-pc-mingw32,$(1)),
	    $(error Deprecated target specified: "$(1)". Please use \
	            i686-w64-mingw32.[$(subst $(space),|,$(MXE_LIB_TYPES))] instead))
	$(if $(filter $(1),$(MXE_TARGET_LIST) $(BUILD) $(MXE_TRIPLETS)),,
	    $(error Invalid target specified: "$(1)"))
	$(if $(findstring 1,$(words $(subst ., ,$(filter-out $(BUILD),$(1))))),
	    @echo
	    @echo '------------------------------------------------------------'
	    @echo 'Warning: Deprecated target name $(1) specified'
	    @echo
	    @echo 'Please use $(1).[$(subst $(space),|,$(MXE_LIB_TYPES))] instead'
	    @echo 'See index.html for further information'
	    @echo '------------------------------------------------------------'
	    @echo)
endef
$(foreach TARGET,$(MXE_TARGETS),$(eval $(call TARGET_RULE,$(TARGET))))

define PKG_RULE
.PHONY: download-$(1)
download-$(1): $(addprefix download-,$($(1)_DEPS)) download-only-$(1)

.PHONY: download-only-$(1)
download-only-$(1):
	$(and $($(1)_URL),
	@[ -d '$(LOG_DIR)/$(TIMESTAMP)' ] || mkdir -p '$(LOG_DIR)/$(TIMESTAMP)'
	@if ! $(call CHECK_PKG_ARCHIVE,$(1)); then \
	    $(PRINTF_FMT) '[download]' '$(1)'; \
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
endef
$(foreach PKG,$(PKGS),$(eval $(call PKG_RULE,$(PKG))))

define PKG_TARGET_RULE
.PHONY: $(1)
$(1): $(PREFIX)/$(3)/installed/$(1)
$(PREFIX)/$(3)/installed/$(1): $(TOP_DIR)/src/$(1).mk \
                          $(PATCHES) \
                          $(wildcard $(TOP_DIR)/src/$(1)-test*) \
                          $(addprefix $(PREFIX)/$(3)/installed/,$(value $(call LOOKUP_PKG_RULE,$(1),DEPS,$(3)))) \
                          $(and $($(3)_DEPS),$(addprefix $(PREFIX)/$($(3)_DEPS)/installed/,$(filter-out $(MXE_CONF_PKGS),$($($(3)_DEPS)_PKGS)))) \
                          | $(if $(DONT_CHECK_REQUIREMENTS),,check-requirements) \
                          $(if $(value $(call LOOKUP_PKG_RULE,$(1),URL,$(3))),download-only-$(1)) \
                          $(addprefix $(PREFIX)/$(3)/installed/,$(if $(call set_is_not_member,$(1),$(MXE_CONF_PKGS)),$(MXE_CONF_PKGS)))
	@[ -d '$(LOG_DIR)/$(TIMESTAMP)' ] || mkdir -p '$(LOG_DIR)/$(TIMESTAMP)'
	$(if $(value $(call LOOKUP_PKG_RULE,$(1),BUILD,$(3))),
	    @$(PRINTF_FMT) '[build]'    '$(1)' '$(3)',
	    @$(PRINTF_FMT) '[no-build]' '$(1)' '$(3)')
	$(if $(value $(call LOOKUP_PKG_RULE,$(1),MESSAGE,$(3))),
	    @$(PRINTF_FMT) '[message]'  '$(1)' '$(3) $($(call LOOKUP_PKG_RULE,$(1),MESSAGE,$(3)))')
	@touch '$(LOG_DIR)/$(TIMESTAMP)/$(1)_$(3)'
	@ln -sf '$(TIMESTAMP)/$(1)_$(3)' '$(LOG_DIR)/$(1)_$(3)'
	@if ! (time $(MAKE) -f '$(MAKEFILE)' 'build-only-$(1)_$(3)') &> '$(LOG_DIR)/$(TIMESTAMP)/$(1)_$(3)'; then \
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
	$(if $(value $(call LOOKUP_PKG_RULE,$(1),BUILD,$(3))),
	    @$(PRINTF_FMT) '[done]' '$(1)' '$(3)' "`grep -a '^du:.*KiB$$\' '$(LOG_DIR)/$(TIMESTAMP)/$(1)_$(3)' | cut -d ':' -f2 | tail -1`" \
	                                          "`grep -a '^real.*m.*s$$\' '$(LOG_DIR)/$(TIMESTAMP)/$(1)_$(3)' | tr '\t' ' ' | cut -d ' ' -f2 | tail -1`")


.PHONY: build-only-$(1)_$(3)
build-only-$(1)_$(3): PKG = $(1)
build-only-$(1)_$(3): TARGET = $(3)
build-only-$(1)_$(3): BUILD_$(if $(findstring shared,$(3)),SHARED,STATIC) = TRUE
build-only-$(1)_$(3): LIB_SUFFIX = $(if $(findstring shared,$(3)),dll,a)
build-only-$(1)_$(3): BITS = $(if $(findstring x86_64,$(3)),64,32)
build-only-$(1)_$(3): CMAKE_TOOLCHAIN_FILE = $(PREFIX)/$(3)/share/cmake/mxe-conf.cmake
build-only-$(1)_$(3): CMAKE_TOOLCHAIN_DIR  = $(PREFIX)/$(3)/share/cmake/mxe-conf.d
build-only-$(1)_$(3): CMAKE_STATIC_BOOL = $(if $(findstring shared,$(3)),OFF,ON)
build-only-$(1)_$(3): CMAKE_SHARED_BOOL = $(if $(findstring shared,$(3)),ON,OFF)
build-only-$(1)_$(3):
	$(if $(value $(call LOOKUP_PKG_RULE,$(1),BUILD,$(3))),
	    uname -a
	    git show-branch --list --reflog=1
	    lsb_release -a 2>/dev/null || sw_vers 2>/dev/null || true
	    autoconf --version 2>/dev/null | head -1
	    automake --version 2>/dev/null | head -1
	    rm -rf   '$(2)'
	    mkdir -p '$(2)'
	    $$(if $(value $(call LOOKUP_PKG_RULE,$(1),FILE,$(3))),\
	        $$(call PREPARE_PKG_SOURCE,$(1),$(2)))
	    $$(call $(call LOOKUP_PKG_RULE,$(1),BUILD,$(3)),$(2)/$($(1)_SUBDIR),$(TOP_DIR)/src/$(1)-test)
	    @echo
	    @find '$(2)' -name 'config.log' -print -exec cat {} \;
	    @echo
	    @echo 'settings.mk'
	    @cat '$(TOP_DIR)/settings.mk'
	    (du -k -d 0 '$(2)' 2>/dev/null || du -k --max-depth 0 '$(2)') | $(SED) -n 's/^\(\S*\).*/du: \1 KiB/p'
	    rm -rfv  '$(2)'
	    )
	touch '$(PREFIX)/$(3)/installed/$(1)'
endef
$(foreach TARGET,$(MXE_TARGETS), \
    $(shell [ -d '$(PREFIX)/$(TARGET)/installed' ] || mkdir -p '$(PREFIX)/$(TARGET)/installed') \
    $(foreach PKG,$($(TARGET)_PKGS), \
        $(eval $(call PKG_TARGET_RULE,$(PKG),$(call TMP_DIR,$(PKG)-$(TARGET)),$(TARGET)))))

# convenience set-like functions for unique lists
SET_APPEND = \
    $(eval $(1) := $(sort $($(1)) $(2)))

SET_CLEAR = \
    $(eval $(1) := )

# WALK functions accept a list of pkgs and/or wildcards
WALK_UPSTREAM = \
    $(strip \
        $(foreach PKG,$(filter $(1),$(PKGS)),\
            $(foreach DEP,$($(PKG)_DEPS) $(foreach TARGET,$(MXE_TARGETS),\
                $(value $(call LOOKUP_PKG_RULE,$(PKG),DEPS,$(TARGET)))),\
                    $(if $(filter-out $(PKGS_VISITED),$(DEP)),\
                        $(call SET_APPEND,PKGS_VISITED,$(DEP))\
                        $(call WALK_UPSTREAM,$(DEP))\
                        $(DEP)))))

# not really walking downstream - that seems to be quadratic, so take
# a linear approach and filter the fully expanded upstream for each pkg
WALK_DOWNSTREAM = \
    $(strip \
        $(foreach PKG,$(PKGS),\
            $(call SET_CLEAR,PKGS_VISITED)\
            $(eval $(PKG)_DEPS_ALL := $(call WALK_UPSTREAM,$(PKG))))\
        $(foreach PKG,$(PKGS),\
            $(if $(filter $(1),$($(PKG)_DEPS_ALL)),$(PKG))))

# EXCLUDE_PKGS can be a list of pkgs and/or wildcards
RECURSIVELY_EXCLUDED_PKGS = \
    $(sort \
        $(filter $(EXCLUDE_PKGS),$(PKGS))\
        $(call SET_CLEAR,PKGS_VISITED)\
        $(call WALK_DOWNSTREAM,$(EXCLUDE_PKGS)))

.PHONY: all-filtered
all-filtered: $(filter-out $(call RECURSIVELY_EXCLUDED_PKGS),$(FILTERED_PKGS))

# print a list of upstream dependencies and downstream dependents
show-deps-%:
	$(if $(call set_is_member,$*,$(PKGS)),\
	    $(call SET_CLEAR,PKGS_VISITED)\
	    $(info $* upstream dependencies:$(newline)\
	        $(call WALK_UPSTREAM,$*)\
	        $(newline)$(newline)$* downstream dependents:$(newline)\
	        $(call WALK_DOWNSTREAM,$*))\
	    @echo,\
	    $(error Package $* not found in index.html))

# show upstream dependencies and downstream dependents separately
# suitable for usage in shell with: `make show-downstream-deps-foo`
# @echo -n suppresses the "Nothing to be done" without an eol
show-downstream-deps-%:
	$(if $(call set_is_member,$*,$(PKGS)),\
	    $(call SET_CLEAR,PKGS_VISITED)\
	    $(info $(call WALK_DOWNSTREAM,$*))\
	    @echo -n,\
	    $(error Package $* not found in index.html))

show-upstream-deps-%:
	$(if $(call set_is_member,$*,$(PKGS)),\
	    $(call SET_CLEAR,PKGS_VISITED)\
	    $(info $(call WALK_UPSTREAM,$*))\
	    @echo -n,\
	    $(error Package $* not found in index.html))

# print first level pkg deps for use in build-pkg.lua
.PHONY: print-deps-for-build-pkg
print-deps-for-build-pkg:
	$(foreach TARGET,$(MXE_TARGETS), \
	    $(foreach PKG,$(sort $($(TARGET)_PKGS)), \
	        $(info for-build-pkg $(TARGET)~$(PKG) \
	        $(subst $(space),-,$($(PKG)_VERSION)) \
	        $(addprefix $(TARGET)~,$(value $(call LOOKUP_PKG_RULE,$(PKG),DEPS,$(TARGET)))) \
	        $(addprefix $(TARGET)~,$(if $(call set_is_not_member,$(PKG),$(MXE_CONF_PKGS)),$(MXE_CONF_PKGS))) \
	        $(and $($(TARGET)_DEPS),$(addprefix $($(TARGET)_DEPS)~,$($($(TARGET)_DEPS)_PKGS))))))
	        @echo -n

BUILD_PKG_TMP_FILES := *-*.list mxe-*.tar.xz mxe-*.deb* wheezy jessie

.PHONY: clean
clean:
	rm -rf $(call TMP_DIR,*) $(PREFIX) build-matrix.html \
	       $(addprefix $(TOP_DIR)/, $(BUILD_PKG_TMP_FILES))

.PHONY: clean-pkg
clean-pkg:
	rm -f $(patsubst %,'%', \
                  $(filter-out \
                      $(foreach PKG,$(PKGS),$(PKG_DIR)/$($(PKG)_FILE)), \
                      $(wildcard $(PKG_DIR)/*)))

.PHONY: clean-junk
clean-junk: clean-pkg
	rm -rf $(LOG_DIR) $(call TMP_DIR,*)

.PHONY: update
define UPDATE
    $(if $(2),
        $(if $(filter $($(1)_IGNORE),$(2)),
            $(info IGNORED  $(1)  $(2)),
            $(if $(filter $(2),$(shell printf '$($(1)_VERSION)\n$(2)' | $(SORT) -V | head -1)),
                $(if $(filter $(2),$($(1)_VERSION)),
                    $(info .        $(1)  $(2)),
                    $(info OLD      $(1)  $($(1)_VERSION) --> $(2) ignoring)),
                $(info NEW      $(1)  $($(1)_VERSION) --> $(2))
                $(if $(findstring undefined, $(origin UPDATE_DRYRUN)),
                    $(SED) -i 's/^\([^ ]*_VERSION *:=\).*/\1 $(2)/' '$(TOP_DIR)/src/$(1).mk'
                    $(MAKE) -f '$(MAKEFILE)' 'update-checksum-$(1)' \
                        || { $(SED) -i 's/^\([^ ]*_VERSION *:=\).*/\1 $($(1)_VERSION)/' '$(TOP_DIR)/src/$(1).mk'; \
                             exit 1; }))),
        $(info Unable to update version number of package $(1) \
            $(newline)$(newline)$($(1)_UPDATE)$(newline)))

endef
update:
	$(foreach PKG,$(PKGS),$(call UPDATE,$(PKG),$(shell $($(PKG)_UPDATE))))

update-package-%:
	$(if $(call set_is_member,$*,$(PKGS)), \
	    $(call UPDATE,$*,$(shell $($*_UPDATE))), \
	    $(error Package $* not found in index.html))

update-checksum-%:
	$(if $(call set_is_member,$*,$(PKGS)), \
	    $(call DOWNLOAD_PKG_ARCHIVE,$*) && \
	    $(SED) -i 's/^\([^ ]*_CHECKSUM *:=\).*/\1 '"`$(call PKG_CHECKSUM,$*)`"'/' '$(TOP_DIR)/src/$*.mk', \
	    $(error Package $* not found in index.html))

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
	$(foreach FILE,$(wildcard $(addprefix $(TOP_DIR)/,Makefile index.html CNAME src/*.mk src/*test.* tools/*)),$(call CLEANUP_STYLE,$(FILE)))

.PHONY: cleanup-deps-style
cleanup-deps-style:
	@grep '(PKG)_DEPS.*\\' '$(TOP_DIR)'/src/*.mk > $(TOP_DIR)/tmp-$@-pre
	@$(foreach PKG,$(PKGS), \
	    $(if $(call lne,$(sort $(filter-out gcc,$($(PKG)_DEPS))),$(filter-out gcc,$($(PKG)_DEPS))), \
	        $(info [cleanup] $(PKG)) \
	        $(SED) -i 's/^\([^ ]*_DEPS *:=\).*/\1 '"$(strip $(filter gcc,$($(PKG)_DEPS)) $(sort $(filter-out gcc,$($(PKG)_DEPS))))"'/' '$(TOP_DIR)/src/$(PKG).mk'; \
	    ))
	@grep '(PKG)_DEPS.*\\' '$(TOP_DIR)'/src/*.mk > $(TOP_DIR)/tmp-$@-post
	@diff -u $(TOP_DIR)/tmp-$@-pre $(TOP_DIR)/tmp-$@-post >/dev/null \
	     || echo '*** Multi-line deps are mangled ***' && comm -3 tmp-$@-pre tmp-$@-post
	@rm -f $(TOP_DIR)/tmp-$@-*

build-matrix.html: $(foreach PKG,$(PKGS), $(TOP_DIR)/src/$(PKG).mk)
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
	@$(foreach PKG,$(PKGS),                      \
	    $(eval $(PKG)_VIRTUAL := $(true))        \
	    $(eval $(PKG)_BUILD_ONLY := $(true))     \
	    echo -e '<tr>\n                          \
	        <th class="row">$(PKG)</th>\n        \
	        <td>$(call substr,$($(PKG)_VERSION),1,12)$(if $(call gt,$(call strlen,$($(PKG)_VERSION)),12),&hellip;)</td>\n\
	    $(foreach TARGET,$(MXE_TARGET_LIST),     \
	        $(if $(value $(call LOOKUP_PKG_RULE,$(PKG),BUILD,$(TARGET))), \
	            $(eval $(TARGET)_PKGCOUNT += x) \
	            $(eval $(PKG)_VIRTUAL := $(false)) \
	            $(eval $(PKG)_BUILD_ONLY := $(false)) \
	            <td class="supported">&#x2713;</td>,            \
	            <td class="unsupported">&#x2717;</td>)\n)       \
	    $(if $(call set_is_member,$(PKG),$(BUILD_PKGS)),        \
	        $(eval $(PKG)_VIRTUAL := $(false))   \
	        <td class="supported">&#x2713;</td>, \
	        <td class="unsupported">&#x2717;</td>)\n \
	        </tr>\n' >> $@ $(newline)            \
	    $(if $($(PKG)_VIRTUAL),                  \
	       $(eval VIRTUAL_PKGCOUNT += x) \
	        $(eval $(PKG)_BUILD_ONLY := $(false))) \
	    $(if $($(PKG)_BUILD_ONLY),               \
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
	@echo '<th>$(words $(BUILD_PKGS))</th>' >> $@
	@echo '</tr>'                           >> $@
	@echo '</tbody>'                        >> $@
	@echo '</table>'                        >> $@
	@echo '</body>'                         >> $@
	@echo '</html>'                         >> $@

.PHONY: versions.json
versions.json: $(foreach PKG,$(PKGS), $(TOP_DIR)/src/$(PKG).mk)
	@echo '{'                         > $@
	@{$(foreach PKG,$(PKGS),          \
	    echo '    "$(PKG)":           \
	        "$($(PKG)_VERSION)",';)} >> $@
	@echo '    "": null'             >> $@
	@echo '}'                        >> $@
