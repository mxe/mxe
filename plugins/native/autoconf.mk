# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := autoconf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.72
$(PKG)_CHECKSUM := ba885c1319578d6c94d46e9b0dceb4014caafe2490e437a0dbca3f270a223f5a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ftp.gnu.org/gnu/autoconf/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/autoconf/$($(PKG)_FILE)
$(PKG)_WEBSITE  := https://www.gnu.org/software/autoconf
$(PKG)_OWNER    := https://github.com/tonytheodore
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_DEPS     := m4

REQUIREMENTS := $(filter-out $(PKG), $(REQUIREMENTS))

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/autoconf/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="autoconf-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD_$(BUILD)
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
