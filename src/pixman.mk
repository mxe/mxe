# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pixman
$(PKG)_WEBSITE  := https://cairographics.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.46.0
$(PKG)_CHECKSUM := 02d9ff7b8458ef61731c3d355f854bbf461fd0a4d3563c51f1c1c7b00638050d
$(PKG)_SUBDIR   := pixman-$($(PKG)_VERSION)
$(PKG)_FILE     := pixman-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://cairographics.org/releases/$($(PKG)_FILE)
$(PKG)_URL_2    := https://xorg.freedesktop.org/archive/individual/lib/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper libpng

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://cairographics.org/releases/?C=M;O=D' | \
    $(SED) -n 's,.*"pixman-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
