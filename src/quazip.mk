# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := quazip
$(PKG)_WEBSITE  := https://github.com/stachenov/quazip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.1
$(PKG)_CHECKSUM := 4fda4d4248e08015b5090d0369ef9e68bdc4475aa12494f7c0f6d79e43270d14
$(PKG)_GH_CONF  := stachenov/quazip/tags,v
$(PKG)_DEPS     := cc qtbase zlib

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' '$(SOURCE_DIR)' \
        'static:CONFIG += staticlib' \
        PREFIX=$(PREFIX)/$(TARGET) \
        -after \
        'SUBDIRS = quazip' \
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
