# MinGW cross compiling environment
# see doc/README for further information

JOBS               := 1
TARGET             := i386-mingw32msvc
SOURCEFORGE_MIRROR := kent.dl.sourceforge.net

VERSION := 2.3
PREFIX  := $(PWD)/usr
PKG_DIR := $(PWD)/pkg
TMP_DIR  = $(PWD)/tmp-$(1)
TOP_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
PATH    := $(PREFIX)/bin:$(PATH)
SHELL   := bash
SED     := $(shell gsed --version >/dev/null 2>&1 && echo g)sed

PKG_RULES := $(patsubst $(TOP_DIR)/src/%.mk,%,$(wildcard $(TOP_DIR)/src/*.mk))
include $(TOP_DIR)/src/*.mk

CHECK_ARCHIVE = \
    $(if $(filter %.tgz,    $(1)),tar tfz '$(1)' >/dev/null 2>&1, \
    $(if $(filter %.tar.gz, $(1)),tar tfz '$(1)' >/dev/null 2>&1, \
    $(if $(filter %.tar.bz2,$(1)),tar tfj '$(1)' >/dev/null 2>&1, \
    $(if $(filter %.zip,    $(1)),unzip -t '$(1)' >/dev/null 2>&1, \
    $(error Unknown archive format: $(1))))))

UNPACK_ARCHIVE = \
    $(if $(filter %.tgz,    $(1)),tar xvzf '$(1)', \
    $(if $(filter %.tar.gz, $(1)),tar xvzf '$(1)', \
    $(if $(filter %.tar.bz2,$(1)),tar xvjf '$(1)', \
    $(if $(filter %.zip,    $(1)),unzip '$(1)', \
    $(error Unknown archive format: $(1))))))

DOWNLOAD = \
    $(if $(2),wget -t 3 -c '$(1)' || wget -c '$(2)',wget -c '$(1)')

.PHONY: all
all: $(PKG_RULES)

define PKG_RULE
.PHONY: $(1)
$(1): $(PREFIX)/installed-$(1)
$(PREFIX)/installed-$(1): $(TOP_DIR)/src/$(1).mk $(addprefix $(PREFIX)/installed-,$($(1)_DEPS))
	[ -d '$(PREFIX)' ] || mkdir -p '$(PREFIX)'
	[ -d '$(PKG_DIR)' ] || mkdir -p '$(PKG_DIR)'
	cd '$(PKG_DIR)' && ( \
	    $(call CHECK_ARCHIVE,$($(1)_FILE)) || \
	    $(call DOWNLOAD,$($(1)_URL),$($(1)_URL_2)) )
	$(if $(value $(1)_BUILD),
	    rm -rf   '$(2)'
	    mkdir -p '$(2)'
	    cd '$(2)' && \
	        $(call UNPACK_ARCHIVE,$(PKG_DIR)/$($(1)_FILE))
	    cd '$(2)/$($(1)_SUBDIR)'
	    $$(call $(1)_BUILD,$(2)/$($(1)_SUBDIR))
	    rm -rfv  '$(2)'
	    ,)
	touch '$$@'
endef
$(foreach PKG,$(PKG_RULES),$(eval $(call PKG_RULE,$(PKG),$(call TMP_DIR,$(PKG)))))

.PHONY: strip
strip:
	rm -rf \
	    $(PREFIX)/include \
	    $(PREFIX)/info \
	    $(PREFIX)/lib/libiberty.a \
	    $(PREFIX)/man \
	    $(PREFIX)/share \
	    $(PREFIX)/$(TARGET)/doc \
	    $(PREFIX)/$(TARGET)/info \
	    $(PREFIX)/$(TARGET)/man \
	    $(PREFIX)/$(TARGET)/sbin \
	    $(PREFIX)/$(TARGET)/share
	-strip -s \
	    $(PREFIX)/bin/* \
	    $(PREFIX)/libexec/gcc/$(TARGET)/*/* \
	    $(PREFIX)/$(TARGET)/bin/*
	-$(TARGET)-strip -g \
	    $(PREFIX)/lib/gcc/$(TARGET)/*/*.a \
	    $(PREFIX)/lib/gcc/$(TARGET)/*/*.o \
	    $(PREFIX)/$(TARGET)/lib/*.a \
	    $(PREFIX)/$(TARGET)/lib/*.o

.PHONY: clean
clean:
	rm -rf $(call TMP_DIR,*) $(PREFIX)/*

.PHONY: update
define UPDATE
    $(if $(2), \
        $(info $(1): $(2)) \
        $(if $(filter $(2),$($(1)_VERSION)), \
            , \
            $(SED) 's/^\([^ ]*_VERSION *:=\).*/\1 $(2)/' -i '$(TOP_DIR)/src/$(1).mk'), \
        $(error Unable to update version number: $(1)))

endef
update:
	$(foreach PKG,$(PKG_RULES),$(call UPDATE,$(PKG),$(shell $($(PKG)_UPDATE))))

.PHONY: dist
dist:
	rm -rf 'mingw_cross_env-$(VERSION)'
	mkdir  'mingw_cross_env-$(VERSION)'
	mkdir  'mingw_cross_env-$(VERSION)/doc'
	mkdir  'mingw_cross_env-$(VERSION)/src'
	(cd '$(TOP_DIR)' && hg log -v --style changelog) >'mingw_cross_env-$(VERSION)/doc/ChangeLog'
	( \
	    $(SED) -n '1,/^List/ { s/^\(    Version:\).*/\1 $(VERSION)/; p }' '$(TOP_DIR)/doc/README' && \
	    echo '================' && \
	    echo && \
	    ($(foreach PKG,$(PKG_RULES),echo '$(PKG)' '$($(PKG)_VERSION)';)) | \
	        awk '{ printf "    %-12s  %s\n", $$1, $$2 }' && \
	    echo && \
	    echo && \
	    $(SED) -n '/^Copyright/,$$ p' '$(TOP_DIR)/doc/README' \
	) >'mingw_cross_env-$(VERSION)/doc/README'
	cp -p '$(TOP_DIR)/Makefile' 'mingw_cross_env-$(VERSION)/'
	cp -p '$(TOP_DIR)/src'/*.mk 'mingw_cross_env-$(VERSION)/src/'
	tar cvf - 'mingw_cross_env-$(VERSION)' | gzip -9 >'mingw_cross_env-$(VERSION).tar.gz'
	rm -rf 'mingw_cross_env-$(VERSION)'

