# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := patch
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.7.5
$(PKG)_CHECKSUM := 7436f5a19f93c3ca83153ce9c5cbe4847e97c5d956e57a220121e741f6e7968f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_WEBSITE  := https://www.gnu.org/software/$(PKG)
$(PKG)_OWNER    := https://github.com/tonytheodore
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_DEPS     :=

REQUIREMENTS := $(filter-out $(PKG), $(REQUIREMENTS))

# recursive variable so always use literal instead of $(PKG)
MXE_REQS_PKGS   += $(BUILD)~patch

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/patch/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="patch-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD_$(BUILD)
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' man1_MANS=
    $(MAKE) -C '$(1).build' -j 1 install man1_MANS=
endef
