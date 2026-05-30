# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libudfread
$(PKG)_WEBSITE  := https://code.videolan.org/videolan/libudfread
$(PKG)_DESCR    := UDF reader library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := bb477cbd4cfbfc7787d9d05b71ee5e70430f5cfebf1297497f7e83547958050f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.xz
$(PKG)_URL      := https://download.videolan.org/pub/videolan/libudfread/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.videolan.org/pub/videolan/libudfread/' | \
    $(SED) -n 's,.*href="libudfread-\([0-9][^>]*\)\.tar.*,\1,p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
