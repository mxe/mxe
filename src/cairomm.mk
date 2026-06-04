# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cairomm
$(PKG)_WEBSITE  := https://cairographics.org/cairomm/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.14.6
$(PKG)_CHECKSUM := 7e0d5c7f29175d573a03ab5c45aef63f48dd91a5caf335a404cd763e4b7cea4a
$(PKG)_SUBDIR   := cairomm-$($(PKG)_VERSION)
$(PKG)_FILE     := cairomm-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://cairographics.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper cairo libsigc++

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://cairographics.org/releases/?C=M;O=D' | \
    $(SED) -n 's,.*"cairomm-\(1\.14\.[0-9]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dbuild-examples=false \
        -Dbuild-tests=false \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef

