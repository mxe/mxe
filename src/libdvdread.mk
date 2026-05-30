# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libdvdread
$(PKG)_WEBSITE  := https://www.videolan.org/developers/libdvdnav.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.0.1
$(PKG)_CHECKSUM := 2e3e04a305c15c3963aa03ae1b9a83c1d239880003fcf3dde986d3943355d407
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.videolan.org/pub/videolan/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)

# libdvdread supports libdvdcss either by dynamic loading (dlfcn-win32) or
# directly linking to libdvdcss. We directly link to the library here.
$(PKG)_DEPS     := cc libdvdcss

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.videolan.org/pub/videolan/libdvdread/' | \
    $(SED) -n 's,.*href="\([0-9][^<]*\)/".*,\1,p' | \
    grep -v 'alpha\|beta\|rc' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    # build and install the library
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Denable_docs=false \
        -Dlibdvdcss=enabled \
        $(PKG_MESON_OPTS) \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
