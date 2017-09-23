# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := tinyxml2
$(PKG)_WEBSITE  := http://grinninglizard.com/tinyxml2/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.0.1
$(PKG)_CHECKSUM := cd33f70a856b681506e3650f9f5f5e5e6c7232da7fa3cfc4e8f56fe7b77dd735
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/leethomason/tinyxml2/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/leethomason/tinyxml2/releases' | \
    $(SED) -n 's,.*/archive/\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-g++' \
        -W -Wall -ansi -pedantic \
        '$(SOURCE_DIR)/xmltest.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
