# MinGW cross compiling environment
# see doc/index.html or doc/README for further information

JOBS               := 1
TARGET             := i386-mingw32msvc
SOURCEFORGE_MIRROR := kent.dl.sourceforge.net

VERSION  := 2.6
PREFIX   := $(PWD)/usr
PKG_DIR  := $(PWD)/pkg
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

PKG_RULES := $(patsubst $(TOP_DIR)/src/%.mk,%,$(wildcard $(TOP_DIR)/src/*.mk))
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
    openssl sha1 '$(PKG_DIR)/$($(1)_FILE)' | $(SED) -n 's,^.*\([0-9a-f]\{40\}\)$$,\1,p'

CHECK_PKG_ARCHIVE = \
    [ '$($(1)_CHECKSUM)' == "`$$(call PKG_CHECKSUM,$(1))`" ]

DOWNLOAD_PKG_ARCHIVE = \
    $(if $($(1)_URL_2), \
        wget -T 30 -t 3 -c -O '$(PKG_DIR)/$($(1)_FILE)' '$($(1)_URL)' \
        || wget -c -O '$(PKG_DIR)/$($(1)_FILE)' '$($(1)_URL_2)', \
        wget -c -O '$(PKG_DIR)/$($(1)_FILE)' '$($(1)_URL)')

.PHONY: all
all: $(PKG_RULES)

define PKG_RULE
.PHONY: $(1)
$(1): $(PREFIX)/installed-$(1)
$(PREFIX)/installed-$(1): $(TOP_DIR)/src/$(1).mk \
                          $(wildcard $(TOP_DIR)/src/$(1)-*.patch) \
                          $(addprefix $(PREFIX)/installed-,$($(1)_DEPS))
	[ -d '$(PREFIX)' ] || mkdir -p '$(PREFIX)'
	[ -d '$(PKG_DIR)' ] || mkdir -p '$(PKG_DIR)'
	if ! $(call CHECK_PKG_ARCHIVE,$(1)); then \
	    $(call DOWNLOAD_PKG_ARCHIVE,$(1)); \
	    $(call CHECK_PKG_ARCHIVE,$(1)) || { echo 'Wrong checksum!'; exit 1; }; \
	    fi
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
	touch '$$@'
endef
$(foreach PKG,$(PKG_RULES),$(eval $(call PKG_RULE,$(PKG),$(call TMP_DIR,$(PKG)))))

.PHONY: strip
strip:
	rm -rf \
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
                      $(foreach PKG,$(PKG_RULES),$(PKG_DIR)/$($(PKG)_FILE)), \
                      $(wildcard $(PKG_DIR)/*)))

.PHONY: update
define UPDATE
    $(if $(2),
        $(info $(1): $(2))
        $(if $(filter $(2),$($(1)_VERSION)),
            ,
            $(SED) 's/^\([^ ]*_VERSION *:=\).*/\1 $(2)/' -i '$(TOP_DIR)/src/$(1).mk'
            $(MAKE) -f '$(MAKEFILE)' 'update-checksum-$(1)'),
        $(error Unable to update version number: $(1)))

endef
update:
	$(foreach PKG,$(PKG_RULES),$(call UPDATE,$(PKG),$(shell $($(PKG)_UPDATE))))

update-checksum-%:
	$(call DOWNLOAD_PKG_ARCHIVE,$*)
	$(SED) 's/^\([^ ]*_CHECKSUM *:=\).*/\1 '"`$(call PKG_CHECKSUM,$*)`"'/' -i '$(TOP_DIR)/src/$*.mk'

.PHONY: dist
dist:
	rm -rf 'mingw_cross_env-$(VERSION)'
	mkdir  'mingw_cross_env-$(VERSION)'
	mkdir  'mingw_cross_env-$(VERSION)/doc'
	mkdir  'mingw_cross_env-$(VERSION)/src'
	(cd '$(TOP_DIR)' && hg log -v --style changelog) >'mingw_cross_env-$(VERSION)/doc/ChangeLog'
	( \
	    $(SED) -n '1,/<!-- begin of package list -->/ p' '$(TOP_DIR)/doc/index.html' && \
	    ($(foreach PKG,$(PKG_RULES), \
	        echo '    <tr><td><a href="$($(PKG)_WEBSITE)">$(PKG)</a></td><td>$($(PKG)_VERSION)</td></tr>';)) && \
	    $(SED) -n '/<!-- end of package list -->/,$$ p' '$(TOP_DIR)/doc/index.html' \
	) \
	| $(SED) 's,\(<span class="version">\)[^<]*\(</span>\),\1$(VERSION)\2,g' \
	| $(SED) 's,\(<span class="target">\)[^<]*\(</span>\),\1$(TARGET)\2,g' \
	>'$(TOP_DIR)/index.html'
	cp -p '$(TOP_DIR)/index.html'       'mingw_cross_env-$(VERSION)/doc/'
	cp -p '$(TOP_DIR)/doc'/screenshot-* 'mingw_cross_env-$(VERSION)/doc/'
	cd 'mingw_cross_env-$(VERSION)/doc' && lynx -dump -width 75 -nolist -force_html index.html >README
	cp -p '$(TOP_DIR)/Makefile'    'mingw_cross_env-$(VERSION)/'
	cp -p '$(TOP_DIR)/src'/*.mk    'mingw_cross_env-$(VERSION)/src/'
	cp -p '$(TOP_DIR)/src'/*.patch 'mingw_cross_env-$(VERSION)/src/'
	tar cvf - 'mingw_cross_env-$(VERSION)' | gzip -9 >'mingw_cross_env-$(VERSION).tar.gz'
	rm -rf 'mingw_cross_env-$(VERSION)'

