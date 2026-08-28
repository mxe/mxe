# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := harfbuzz
$(PKG)_WEBSITE  := https://wiki.freedesktop.org/www/Software/HarfBuzz/
$(PKG)_DESCR    := HarfBuzz
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 14.4.0
$(PKG)_CHECKSUM := 2357ed966c6ced7bfa720b0640c0231065af01158fbea215093ffa15aed44371
$(PKG)_GH_CONF  := harfbuzz/harfbuzz/releases,,,v0,,.tar.xz
$(PKG)_DEPS     := cc meson-wrapper brotli cairo freetype-bootstrap glib icu4c

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dchafa=disabled \
        -Dbenchmark=disabled \
        -Dtests=disabled \
        -Ddocs=disabled \
        -Dintrospection=disabled \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    # mman-win32 is only a partial implementation
    $(SED) -i '/HAVE_SYS_MMAN_H/d' '$(BUILD_DIR)/config.h'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
