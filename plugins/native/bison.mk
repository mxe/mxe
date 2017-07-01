# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := bison
$(PKG)_IGNORE   := 3%
$(PKG)_VERSION  := 2.7.1
$(PKG)_CHECKSUM := b409adcbf245baadb68d2f66accf6fdca5e282cafec1b865f4b5e963ba8ea7fb
$(PKG)_SUBDIR   := bison-$($(PKG)_VERSION)
$(PKG)_FILE     := bison-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ftp.gnu.org/gnu/bison/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/bison/$($(PKG)_FILE)
$(PKG)_WEBSITE  := https://www.gnu.org/software/bison
$(PKG)_OWNER    := https://github.com/tonytheodore
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_DEPS     := flex

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/bison/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="bison-\([0-9][^"]*\)\.tar.*,\1,p' | \
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
