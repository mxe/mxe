# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ragel
$(PKG)_WEBSITE  := https://www.colm.net/open-source/ragel/
$(PKG)_DESCR    := Ragel
$(PKG)_IGNORE   := 7%
$(PKG)_VERSION  := 6.9
$(PKG)_CHECKSUM := 6e07be0fab5ca1d9c2d9e177718a018fc666141f594a5d6e7025658620cf660a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.colm.net/files/ragel/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.colm.net/open-source/ragel/' | \
    $(SED) -n 's,.*ragel-\([0-9.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD_$(BUILD)
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        --prefix='$(PREFIX)/$(BUILD)' \
        CXXFLAGS=-std=c++03
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
