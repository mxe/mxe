# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := harfbuzz
$(PKG)_WEBSITE  := https://wiki.freedesktop.org/www/Software/HarfBuzz/
$(PKG)_DESCR    := HarfBuzz
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 10.2.0
$(PKG)_CHECKSUM := 620e3468faec2ea8685d32c46a58469b850ef63040b3565cde05959825b48227
$(PKG)_GH_CONF  := harfbuzz/harfbuzz/releases,,,,,.tar.xz
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
