# This file is part of MXE.
# See index.html for further information.

JOBS               := 1
TARGET             := i686-pc-mingw32
SOURCEFORGE_MIRROR := kent.dl.sourceforge.net

PWD        := $(shell pwd)
SHELL      := bash

INSTALL    := $(shell ginstall --help >/dev/null 2>&1 && echo g)install
LIBTOOL    := $(shell glibtool --help >/dev/null 2>&1 && echo g)libtool
LIBTOOLIZE := $(shell glibtoolize --help >/dev/null 2>&1 && echo g)libtoolize
PATCH      := $(shell gpatch --help >/dev/null 2>&1 && echo g)patch
SED        := $(shell gsed --help >/dev/null 2>&1 && echo g)sed

REQUIREMENTS := autoconf automake bash bison bzip2 cmake flex \
                gcc intltoolize $(LIBTOOL) $(LIBTOOLIZE) \
                $(MAKE) openssl $(PATCH) $(PERL) pkg-config \
                scons $(SED) unzip wget xz yasm

PREFIX     := $(PWD)/usr
LOG_DIR    := $(PWD)/log
TIMESTAMP  := $(shell date +%Y%m%d_%H%M%S)
PKG_DIR    := $(PWD)/pkg
TMP_DIR     = $(PWD)/tmp-$(1)
MAKEFILE   := $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
TOP_DIR    := $(patsubst %/,%,$(dir $(MAKEFILE)))
PKGS       := $(shell $(SED) -n 's/^.* id="\([^"]*\)-package".*$$/\1/p' '$(TOP_DIR)/index.html')
PATH       := $(PREFIX)/bin:$(PATH)

CMAKE_TOOLCHAIN_FILE := $(PREFIX)/$(TARGET)/share/cmake/mxe-conf.cmake

# unexport any environment variables that might cause trouble
unexport AR CC CFLAGS C_INCLUDE_PATH CPATH CPLUS_INCLUDE_PATH CPP
unexport CPPFLAGS CROSS CXX CXXCPP CXXFLAGS EXEEXT EXTRA_CFLAGS
unexport EXTRA_LDFLAGS LD LDFLAGS LIBRARY_PATH LIBS NM
unexport OBJC_INCLUDE_PATH PKG_CONFIG QMAKESPEC RANLIB STRIP

SHORT_PKG_VERSION = \
    $(word 1,$(subst ., ,$($(1)_VERSION))).$(word 2,$(subst ., ,$($(1)_VERSION)))

UNPACK_ARCHIVE = \
    $(if $(filter %.tgz,     $(1)),tar xzf '$(1)', \
    $(if $(filter %.tar.gz,  $(1)),tar xzf '$(1)', \
    $(if $(filter %.tar.bz2, $(1)),tar xjf '$(1)', \
    $(if $(filter %.tar.lzma,$(1)),xz -dc -F lzma '$(1)' | tar xf -, \
    $(if $(filter %.tar.xz,$(1)),xz -dc '$(1)' | tar xf -, \
    $(if $(filter %.zip,     $(1)),unzip -q '$(1)', \
    $(error Unknown archive format: $(1))))))))

UNPACK_PKG_ARCHIVE = \
    $(call UNPACK_ARCHIVE,$(PKG_DIR)/$($(1)_FILE))

PKG_CHECKSUM = \
    openssl sha1 '$(PKG_DIR)/$($(1)_FILE)' 2>/dev/null | $(SED) -n 's,^.*\([0-9a-f]\{40\}\)$$,\1,p'

CHECK_PKG_ARCHIVE = \
    [ '$($(1)_CHECKSUM)' == "`$$(call PKG_CHECKSUM,$(1))`" ]

DOWNLOAD_PKG_ARCHIVE = \
    mkdir -p '$(PKG_DIR)' && \
    $(if $($(1)_URL_2), \
        ( wget -T 30 -t 3 --no-check-certificate -O- '$($(1)_URL)' || wget --no-check-certificate -O- '$($(1)_URL_2)' ), \
        wget --no-check-certificate -O- '$($(1)_URL)') \
    $(if $($(1)_FIX_GZIP), \
        | gzip -d | gzip -9n, \
        ) \
    > '$(PKG_DIR)/$($(1)_FILE)'

.PHONY: all
all: $(PKGS)

.PHONY: check-requirements
define CHECK_REQUIREMENT
    @if ! $(1) --help &>/dev/null; then \
        echo; \
        echo 'Missing requirement: $(1)'; \
        echo; \
        echo 'Please have a look at "index.html" to ensure'; \
        echo 'that your system meets all requirements.'; \
        echo; \
        exit 1; \
    fi

endef
define CHECK_REQUIREMENT_VERSION
    @if ! $(1) --version | head -1 | grep ' \($(2)\)$$' >/dev/null; then \
        echo; \
        echo 'Wrong version of requirement: $(1)'; \
        echo; \
        echo 'Please have a look at "index.html" to ensure'; \
        echo 'that your system meets all requirements.'; \
        echo; \
        exit 1; \
    fi

endef
check-requirements: $(PREFIX)/installed/check-requirements
$(PREFIX)/installed/check-requirements: $(MAKEFILE)
	@echo '[check requirements]'
	$(foreach REQUIREMENT,$(REQUIREMENTS),$(call CHECK_REQUIREMENT,$(REQUIREMENT)))
	$(call CHECK_REQUIREMENT_VERSION,autoconf,2\.6[4-9]\|2\.[7-9][0-9])
	$(call CHECK_REQUIREMENT_VERSION,automake,1\.[1-9][0-9]\(\.[0-9]\+\)\?)
	@[ -d '$(PREFIX)/installed' ] || mkdir -p '$(PREFIX)/installed'
	@touch '$@'

define newline


endef
$(eval $(subst #,$(newline),$(shell \
    $(SED) -n \
        's/^.* id="\([A-Za-z0-9_+-]*\)-version">\([^<]*\)<.*$$/\1_VERSION := \2#/p' \
        '$(TOP_DIR)/index.html' \
)))

include $(patsubst %,$(TOP_DIR)/src/%.mk,$(PKGS))

.PHONY: download
download: $(addprefix download-,$(PKGS))

define PKG_RULE
.PHONY: download-$(1)
download-$(1): $(addprefix download-,$($(1)_DEPS))
	if ! $(call CHECK_PKG_ARCHIVE,$(1)); then \
	    $(call DOWNLOAD_PKG_ARCHIVE,$(1)); \
	    $(call CHECK_PKG_ARCHIVE,$(1)) || { echo 'Wrong checksum!'; exit 1; }; \
	fi

.PHONY: $(1)
$(1): $(PREFIX)/installed/$(1)
$(PREFIX)/installed/$(1): $(TOP_DIR)/src/$(1).mk \
                          $(wildcard $(TOP_DIR)/src/$(1)-*.patch) \
                          $(wildcard $(TOP_DIR)/src/$(1)-test*) \
                          $(addprefix $(PREFIX)/installed/,$($(1)_DEPS)) \
                          | check-requirements
	@[ -d '$(LOG_DIR)/$(TIMESTAMP)' ] || mkdir -p '$(LOG_DIR)/$(TIMESTAMP)'
	@if ! $(call CHECK_PKG_ARCHIVE,$(1)); then \
	    echo '[download] $(1)'; \
	    ($(call DOWNLOAD_PKG_ARCHIVE,$(1))) &> '$(LOG_DIR)/$(TIMESTAMP)/$(1)-download'; \
	    ln -sf '$(TIMESTAMP)/$(1)-download' '$(LOG_DIR)/$(1)-download'; \
	    if ! $(call CHECK_PKG_ARCHIVE,$(1)); then \
	        echo; \
	        echo 'Wrong checksum of package $(1)!'; \
	        echo '------------------------------------------------------------'; \
	        tail -n 10 '$(LOG_DIR)/$(1)-download' | $(SED) -n '/./p'; \
	        echo '------------------------------------------------------------'; \
	        echo '[log]      $(LOG_DIR)/$(1)-download'; \
	        echo; \
	        exit 1; \
	    fi; \
	fi
	$(if $(value $(1)_BUILD),
	    @echo '[build]    $(1)'
	    ,)
	@touch '$(LOG_DIR)/$(TIMESTAMP)/$(1)'
	@ln -sf '$(TIMESTAMP)/$(1)' '$(LOG_DIR)/$(1)'
	@if ! (time $(MAKE) -f '$(MAKEFILE)' 'build-only-$(1)') &> '$(LOG_DIR)/$(TIMESTAMP)/$(1)'; then \
	    echo; \
	    echo 'Failed to build package $(1)!'; \
	    echo '------------------------------------------------------------'; \
	    tail -n 10 '$(LOG_DIR)/$(1)' | $(SED) -n '/./p'; \
	    echo '------------------------------------------------------------'; \
	    echo '[log]      $(LOG_DIR)/$(1)'; \
	    echo; \
	    exit 1; \
	fi
	@echo '[done]     $(1)'

.PHONY: build-only-$(1)
build-only-$(1):
	$(if $(value $(1)_BUILD),
	    rm -rf   '$(2)'
	    mkdir -p '$(2)'
	    cd '$(2)' && $(call UNPACK_PKG_ARCHIVE,$(1))
	    cd '$(2)/$($(1)_SUBDIR)'
	    $(foreach PKG_PATCH,$(sort $(wildcard $(TOP_DIR)/src/$(1)-*.patch)),
	        (cd '$(2)/$($(1)_SUBDIR)' && $(PATCH) -p1 -u) < $(PKG_PATCH))
	    $$(call $(1)_BUILD,$(2)/$($(1)_SUBDIR),$(TOP_DIR)/src/$(1)-test)
	    (du -k -d 0 '$(2)' 2>/dev/null || du -k --max-depth 0 '$(2)') | $(SED) -n 's/^\(\S*\).*/du: \1 KiB/p'
	    rm -rfv  '$(2)'
	    ,)
	[ -d '$(PREFIX)/installed' ] || mkdir -p '$(PREFIX)/installed'
	touch '$(PREFIX)/installed/$(1)'
endef
$(foreach PKG,$(PKGS),$(eval $(call PKG_RULE,$(PKG),$(call TMP_DIR,$(PKG)))))

.PHONY: clean
clean:
	rm -rf $(call TMP_DIR,*) $(PREFIX)/*

.PHONY: clean-pkg
clean-pkg:
	rm -f $(patsubst %,'%', \
                  $(filter-out \
                      $(foreach PKG,$(PKGS),$(PKG_DIR)/$($(PKG)_FILE)), \
                      $(wildcard $(PKG_DIR)/*)))

.PHONY: update
define UPDATE
    $(if $(2),
        $(if $(filter $(2),$($(1)_IGNORE)),
            $(info IGNORED  $(1)  $(2)),
            $(if $(filter $(2),$($(1)_VERSION)),
                $(info .        $(1)  $(2)),
                $(info NEW      $(1)  $($(1)_VERSION) --> $(2))
                $(SED) -i 's/\( id="$(1)-version"\)>[^<]*/\1>$(2)/' '$(TOP_DIR)/index.html'
                $(MAKE) -f '$(MAKEFILE)' 'update-checksum-$(1)' \
                    || { $(SED) -i 's/\( id="$(1)-version"\)>[^<]*/\1>$($(1)_VERSION)/' '$(TOP_DIR)/index.html'; \
                         exit 1; })),
        $(error Unable to update version number of package $(1)))

endef
update:
	$(foreach PKG,$(PKGS),$(call UPDATE,$(PKG),$(shell $($(PKG)_UPDATE))))

update-checksum-%:
	$(call DOWNLOAD_PKG_ARCHIVE,$*)
	$(SED) -i 's/^\([^ ]*_CHECKSUM *:=\).*/\1 '"`$(call PKG_CHECKSUM,$*)`"'/' '$(TOP_DIR)/src/$*.mk'

cleanup-style:
	@$(foreach FILE,$(wildcard $(addprefix $(TOP_DIR)/,Makefile index.html CNAME src/*.mk src/*test.* tools/*)),\
            $(SED) ' \
                s/\r//g; \
                s/[ \t]\+$$//; \
                s,^#!/bin/bash$$,#!/usr/bin/env bash,; \
                $(if $(filter %Makefile,$(FILE)),,\
                    s/\t/    /g; \
                ) \
            ' < $(FILE) > $(TOP_DIR)/tmp-cleanup-style; \
            diff -u $(FILE) $(TOP_DIR)/tmp-cleanup-style >/dev/null \
                || { echo '[cleanup] $(FILE)'; \
                     cp $(TOP_DIR)/tmp-cleanup-style $(FILE); }; \
            rm -f $(TOP_DIR)/tmp-cleanup-style; \
        )

