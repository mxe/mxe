# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libspnav
$(PKG)_WEBSITE  := https://github.com/FreeSpacenav/libspnav
$(PKG)_DESCR    := The FreeSpacenav library for 3D input devices (e.g., spacemouse)
$(PKG)_VERSION  := 1.2
$(PKG)_FILE     := libspnav-$($(PKG)_VERSION).tar.gz
$(PKG)_CHECKSUM := 093747e7e03b232e08ff77f1ad7f48552c06ac5236316a5012db4269951c39db
$(PKG)_SUBDIR   := libspnav-$($(PKG)_VERSION)
$(PKG)_URL      := https://github.com/FreeSpacenav/libspnav/releases/download/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_DEPS     := autotools

define $(PKG)_BUILD
        cd '$(SOURCE_DIR)' && ./configure \
                --host='$(TARGET)' \
                --prefix='$(PREFIX)/$(TARGET)' \
                --disable-shared \
                --enable-static
        $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)'
        $(MAKE) -C '$(SOURCE_DIR)' install
endef
