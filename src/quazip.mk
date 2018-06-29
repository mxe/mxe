# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := quazip
$(PKG)_WEBSITE  := https://github.com/stachenov/quazip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.7.6
$(PKG)_CHECKSUM := 4118a830a375a81211956611cc34b1b5b4ddc108c126287b91b40c2493046b70
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
        'static:CONFIG += staticlib' \
        PREFIX=$(PREFIX)/$(TARGET) \
        -after \
        'win32:LIBS_PRIVATE += -lz' \
        'CONFIG -= dll' \
        'CONFIG += create_prl no_install_prl create_pc' \
        'QMAKE_PKGCONFIG_DESTDIR = pkgconfig' \
        'static:QMAKE_PKGCONFIG_CFLAGS += -DQUAZIP_STATIC' \
        'DESTDIR = ' \
        'DLLDESTDIR = ' \
        'win32:dlltarget.path = $(PREFIX)/$(TARGET)/bin' \
        'target.path = $(PREFIX)/$(TARGET)/lib'  \
        '!static:win32:target.CONFIG = no_dll' \
        'win32:INSTALLS += dlltarget' \
        'INSTALLS += target headers'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-g++' \
        -W -Wall -Werror -std=c++11 -pedantic \
        '$(TOP_DIR)/src/$(PKG)-test.cpp' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG)-pkgconfig.exe' \
        `'$(TARGET)-pkg-config' quazip --cflags --libs`
endef
