# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := harfbuzz
$(PKG)_WEBSITE  := https://wiki.freedesktop.org/www/Software/HarfBuzz/
$(PKG)_DESCR    := HarfBuzz
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2.0
$(PKG)_CHECKSUM := 7152d1bdcbd2bf6ba777cfe9161d40564fe0a7583e04e55e0a057d5f4414d3c9
$(PKG)_GH_CONF  := harfbuzz/harfbuzz/releases
$(PKG)_DEPS     := cc meson-wrapper cairo freetype-bootstrap glib

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dtests=disabled \
        -Ddocs=disabled \
        -Dintrospection=disabled \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    # mman-win32 is only a partial implementation
    $(SED) -i '/HAVE_SYS_MMAN_H/d' '$(BUILD_DIR)/config.h'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
