# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := quazip
$(PKG)_WEBSITE  := https://github.com/stachenov/quazip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.7.5
$(PKG)_CHECKSUM := f3a56647d4706c9daef411e40e3884702e2bd770e980145c3899321788ba8bb2
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_GH_CONF  := stachenov/quazip/tags
$(PKG)_DEPS     := cc qtbase zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/stachenov/quazip/tags' | \
    grep '<a href="/stachenov/quazip/archive/' | \
    $(SED) -n 's,.*href="/stachenov/quazip/archive/\([0-9][^"_]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' '$(SOURCE_DIR)' \
        $(if $(BUILD_STATIC), CONFIG\+=staticlib) \
        PREFIX=$(PREFIX)/$(TARGET)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(if $(BUILD_STATIC), \
        echo 'Cflags.private: -DQUAZIP_STATIC' >> $(BUILD_DIR)/quazip/lib/pkgconfig/quazip.pc)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # qmake misnames and installs import lib to bin
    $(if $(BUILD_SHARED), \
        mv -f $(PREFIX)/$(TARGET)/bin/libquazip.a \
              $(PREFIX)/$(TARGET)/lib/libquazip.dll.a)

    '$(TARGET)-g++' \
        -W -Wall -Werror -std=c++11 -pedantic \
        '$(TOP_DIR)/src/$(PKG)-test.cpp' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG)-pkgconfig.exe' \
        `'$(TARGET)-pkg-config' quazip --cflags --libs`
endef
