# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := harfbuzz
$(PKG)_WEBSITE  := https://wiki.freedesktop.org/www/Software/HarfBuzz/
$(PKG)_DESCR    := HarfBuzz
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.1.0
$(PKG)_CHECKSUM := 5352ff2eec538ea9a63a485cf01ad8332a3f63aa79921c5a2e301cef185caea1
$(PKG)_GH_CONF  := harfbuzz/harfbuzz/releases
$(PKG)_DEPS     := cc meson-wrapper cairo freetype-bootstrap glib icu4c

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
