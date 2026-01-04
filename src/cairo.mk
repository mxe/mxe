# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cairo
$(PKG)_WEBSITE  := https://cairographics.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.18.4
$(PKG)_CHECKSUM := 445ed8208a6e4823de1226a74ca319d3600e83f6369f99b14265006599c32ccb
$(PKG)_SUBDIR   := cairo-$($(PKG)_VERSION)
$(PKG)_FILE     := cairo-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://cairographics.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper fontconfig freetype-bootstrap glib libpng lzo pixman zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://cairographics.org/releases/?C=M;O=D' | \
    $(SED) -n 's,.*"cairo-\([0-9]\.[0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    CFLAGS="-Wno-incompatible-pointer-types" \
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dgtk_doc=false \
        -Dtests=disabled \
        -Dxcb=disabled \
        -Dxlib=disabled \
        -Dxlib-xcb=disabled \
        -Dquartz=disabled \
        -Dpng=enabled \
        -Dfontconfig=enabled \
        -Dfreetype=enabled \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    $(if $(BUILD_STATIC), \
        echo '#define CAIRO_WIN32_STATIC_BUILD 1' >> '$(BUILD_DIR)/src/cairo-features.h',)
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
