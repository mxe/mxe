# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cairomm
$(PKG)_WEBSITE  := https://cairographics.org/cairomm/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.14.3
$(PKG)_CHECKSUM := 0d37e067c5c4ca7808b7ceddabfe1932c5bd2a750ad64fb321e1213536297e78
$(PKG)_SUBDIR   := cairomm-$($(PKG)_VERSION)
$(PKG)_FILE     := cairomm-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://cairographics.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper cairo libsigc++

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://cairographics.org/releases/?C=M;O=D' | \
    $(SED) -n 's,.*"cairomm-\([0-9][^"]*\)\.tar.*,\1,p' | \
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

