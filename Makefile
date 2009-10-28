# MinGW cross compiling environment
# see doc/index.html or doc/README for further information
#
# Copyright (C) 2009  Volker Grabsch
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject
# to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

JOBS               := 1
TARGET             := i686-pc-mingw32
SOURCEFORGE_MIRROR := kent.dl.sourceforge.net

VERSION  := 2.10
PREFIX   := $(PWD)/usr
PKG_DIR  := $(PWD)/pkg
DIST_DIR := $(PWD)/dist
TMP_DIR   = $(PWD)/tmp-$(1)
MAKEFILE := $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
TOP_DIR  := $(patsubst %/,%,$(dir $(MAKEFILE)))
PATH     := $(PREFIX)/bin:$(PATH)
SHELL    := bash
SED      := $(shell gsed --help >/dev/null 2>&1 && echo g)sed
INSTALL  := $(shell ginstall --help >/dev/null 2>&1 && echo g)install

# unset any environment variables which might cause trouble
AR =
CC =
CFLAGS =
CPP =
CPPFLAGS =
CROSS =
CXX =
CXXCPP =
CXXFLAGS =
EXEEXT =
EXTRA_CFLAGS =
EXTRA_LDFLAGS =
LD =
LDFLAGS =
LIBS =
NM =
PKG_CONFIG =
PKG_CONFIG_PATH =
RANLIB =
STRIP =

SHORT_PKG_VERSION = \
    $(word 1,$(subst ., ,$($(1)_VERSION))).$(word 2,$(subst ., ,$($(1)_VERSION)))

PKGS := $(sort $(patsubst $(TOP_DIR)/src/%.mk,%,$(wildcard $(TOP_DIR)/src/*.mk)))
include $(TOP_DIR)/src/*.mk

UNPACK_ARCHIVE = \
    $(if $(filter %.tgz,    $(1)),tar xvzf '$(1)', \
    $(if $(filter %.tar.gz, $(1)),tar xvzf '$(1)', \
    $(if $(filter %.tar.bz2,$(1)),tar xvjf '$(1)', \
    $(if $(filter %.zip,    $(1)),unzip '$(1)', \
    $(error Unknown archive format: $(1))))))

UNPACK_PKG_ARCHIVE = \
    $(call UNPACK_ARCHIVE,$(PKG_DIR)/$($(1)_FILE))

PKG_CHECKSUM = \
    openssl sha1 '$(PKG_DIR)/$($(1)_FILE)' 2>/dev/null | $(SED) -n 's,^.*\([0-9a-f]\{40\}\)$$,\1,p'

CHECK_PKG_ARCHIVE = \
    [ '$($(1)_CHECKSUM)' == "`$$(call PKG_CHECKSUM,$(1))`" ]

DOWNLOAD_PKG_ARCHIVE = \
    $(if $($(1)_URL_2), \
        wget -T 30 -t 3 -c -O '$(PKG_DIR)/$($(1)_FILE)' '$($(1)_URL)' \
        || wget -c -O '$(PKG_DIR)/$($(1)_FILE)' '$($(1)_URL_2)', \
        wget -c -O '$(PKG_DIR)/$($(1)_FILE)' '$($(1)_URL)')

SOURCEFORGE_FILES = \
    wget -q -O- '$(1)' | \
    grep 'title="/' | \
    $(SED) -n 's,.*title="\(/[^:]*\).*released on \([^ "]* [^ "]* [^ "]*\)",\2 \1,p' | \
    while read d1 d2 d3 url; do echo "`date -d "$$d1 $$d2 $$d3" +%Y-%m-%d`" "$$url"; done | \
    sort | \
    $(SED) 's,^[^ ]* ,,'

.PHONY: all
all: $(PKGS)

.PHONY: download
download: $(addprefix download-,$(PKGS))

define PKG_RULE
.PHONY: download-$(1)
download-$(1): $(addprefix download-,$($(1)_DEPS))
	[ -d '$(PKG_DIR)' ] || mkdir -p '$(PKG_DIR)'
	if ! $(call CHECK_PKG_ARCHIVE,$(1)); then \
	    $(call DOWNLOAD_PKG_ARCHIVE,$(1)); \
	    $(call CHECK_PKG_ARCHIVE,$(1)) || { echo 'Wrong checksum!'; exit 1; }; \
	fi

.PHONY: $(1)
$(1): $(PREFIX)/installed-$(1)
$(PREFIX)/installed-$(1): $(TOP_DIR)/src/$(1).mk \
                          $(wildcard $(TOP_DIR)/src/$(1)-*.patch) \
                          $(addprefix $(PREFIX)/installed-,$($(1)_DEPS))
	@[ -d '$(PREFIX)' ] || mkdir -p '$(PREFIX)'
	@[ -d '$(PKG_DIR)' ] || mkdir -p '$(PKG_DIR)'
	@if ! $(call CHECK_PKG_ARCHIVE,$(1)); then \
	    echo '[download] $(1)'; \
	    ($(call DOWNLOAD_PKG_ARCHIVE,$(1))) &> '$(PREFIX)/log-$(1)'; \
	    if ! $(call CHECK_PKG_ARCHIVE,$(1)); then \
	        echo; \
	        echo 'Wrong checksum of package $(1)!'; \
	        echo '------------------------------------------------------------'; \
	        tail -n 10 '$(PREFIX)/log-$(1)' | $(SED) -n '/./p'; \
	        echo '------------------------------------------------------------'; \
	        echo '[log]      $(PREFIX)/log-$(1)'; \
	        echo; \
	        exit 1; \
	    fi; \
	fi
	$(if $(value $(1)_BUILD),
	    @echo '[build]    $(1)'
	    ,)
	@if ! (time $(MAKE) -f '$(MAKEFILE)' 'build-only-$(1)') &> '$(PREFIX)/log-$(1)'; then \
	    echo; \
	    echo 'Failed to build package $(1)!'; \
	    echo '------------------------------------------------------------'; \
	    tail -n 10 '$(PREFIX)/log-$(1)' | $(SED) -n '/./p'; \
	    echo '------------------------------------------------------------'; \
	    echo '[log]      $(PREFIX)/log-$(1)'; \
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
	        (cd '$(2)/$($(1)_SUBDIR)' && patch -p1) < $(PKG_PATCH))
	    $$(call $(1)_BUILD,$(2)/$($(1)_SUBDIR))
	    rm -rfv  '$(2)'
	    ,)
	touch '$(PREFIX)/installed-$(1)'
endef
$(foreach PKG,$(PKGS),$(eval $(call PKG_RULE,$(PKG),$(call TMP_DIR,$(PKG)))))

.PHONY: strip
strip:
	rm -rf \
	    '$(PREFIX)'/log-* \
	    '$(PREFIX)/include' \
	    '$(PREFIX)/info' \
	    '$(PREFIX)/lib/libiberty.a' \
	    '$(PREFIX)/man' \
	    '$(PREFIX)/share' \
	    '$(PREFIX)/$(TARGET)/etc' \
	    '$(PREFIX)/$(TARGET)/doc' \
	    '$(PREFIX)/$(TARGET)/info' \
	    '$(PREFIX)/$(TARGET)/lib'/*.def \
	    '$(PREFIX)/$(TARGET)/man' \
	    '$(PREFIX)/$(TARGET)/sbin' \
	    '$(PREFIX)/$(TARGET)/share'
	-strip -Sx \
	    '$(PREFIX)/bin'/* \
	    '$(PREFIX)/libexec/gcc/$(TARGET)'/*/* \
	    '$(PREFIX)/$(TARGET)/bin'/*
	-$(TARGET)-strip -S \
	    '$(PREFIX)/lib/gcc/$(TARGET)'/*/*.a \
	    '$(PREFIX)/lib/gcc/$(TARGET)'/*/*.o \
	    '$(PREFIX)/$(TARGET)/lib'/*.a \
	    '$(PREFIX)/$(TARGET)/lib'/*.o

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
                $(SED) 's/^\([^ ]*_VERSION *:=\).*/\1 $(2)/' -i '$(TOP_DIR)/src/$(1).mk'
                $(MAKE) -f '$(MAKEFILE)' 'update-checksum-$(1)' \
                    || $(SED) 's/^\([^ ]*_VERSION *:=\).*/\1 $($(1)_VERSION)/' -i '$(TOP_DIR)/src/$(1).mk')),
        $(error Unable to update version number: $(1)))

endef
update:
	$(foreach PKG,$(PKGS),$(call UPDATE,$(PKG),$(shell $($(PKG)_UPDATE))))

update-checksum-%:
	$(call DOWNLOAD_PKG_ARCHIVE,$*)
	$(SED) 's/^\([^ ]*_CHECKSUM *:=\).*/\1 '"`$(call PKG_CHECKSUM,$*)`"'/' -i '$(TOP_DIR)/src/$*.mk'

.PHONY: dist
dist:
	[ -d '$(DIST_DIR)' ]          || mkdir -p '$(DIST_DIR)'
	[ -d '$(DIST_DIR)/web' ]      || mkdir    '$(DIST_DIR)/web'
	[ -d '$(DIST_DIR)/releases' ] || mkdir    '$(DIST_DIR)/releases'
	rm -rf '$(DIST_DIR)/mingw-cross-env-$(VERSION)'
	mkdir  '$(DIST_DIR)/mingw-cross-env-$(VERSION)'
	mkdir  '$(DIST_DIR)/mingw-cross-env-$(VERSION)/doc'
	mkdir  '$(DIST_DIR)/mingw-cross-env-$(VERSION)/src'
	( \
	    $(SED) -n '1,/<!-- begin of package list -->/ p' '$(TOP_DIR)/doc/index.html' && \
	    ($(foreach PKG,$(PKGS), \
	        echo '    <tr><td><a href="$($(PKG)_WEBSITE)">$(PKG)</a></td><td>$($(PKG)_VERSION)</td></tr>';)) && \
	    $(SED) -n '/<!-- end of package list -->/,$$ p' '$(TOP_DIR)/doc/index.html' \
	) \
	| $(SED) 's,\(<span class="version">\)[^<]*\(</span>\),\1$(VERSION)\2,g' \
	| $(SED) 's,\(<span class="target">\)[^<]*\(</span>\),\1$(TARGET)\2,g' \
	>'$(DIST_DIR)/mingw-cross-env-$(VERSION)/doc/index.html'
	cp -p '$(TOP_DIR)/doc'/screenshot-* '$(DIST_DIR)/mingw-cross-env-$(VERSION)/doc/'
	cp -p '$(DIST_DIR)/mingw-cross-env-$(VERSION)/doc'/* '$(DIST_DIR)/web/'
	(cd '$(TOP_DIR)' && hg log -v --style changelog) >'$(DIST_DIR)/mingw-cross-env-$(VERSION)/doc/ChangeLog'
	cd '$(DIST_DIR)/mingw-cross-env-$(VERSION)/doc' && lynx -dump -width 75 -nolist -force_html index.html >README
	cp -p '$(TOP_DIR)/Makefile'    '$(DIST_DIR)/mingw-cross-env-$(VERSION)/'
	cp -p '$(TOP_DIR)/src'/*.mk    '$(DIST_DIR)/mingw-cross-env-$(VERSION)/src/'
	cp -p '$(TOP_DIR)/src'/*.patch '$(DIST_DIR)/mingw-cross-env-$(VERSION)/src/'
	(cd '$(DIST_DIR)' && tar cvf - 'mingw-cross-env-$(VERSION)' | gzip -9) >'$(DIST_DIR)/releases/mingw-cross-env-$(VERSION).tar.gz'
	rm -rf '$(DIST_DIR)/mingw-cross-env-$(VERSION)'

