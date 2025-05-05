# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libepoxy
$(PKG)_WEBSITE  := https://github.com/anholt/libepoxy
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5.10
$(PKG)_CHECKSUM := a7ced37f4102b745ac86d6a70a9da399cc139ff168ba6b8002b4d8d43c900c15
$(PKG)_GH_CONF  := anholt/libepoxy/releases/latest
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/anholt/libepoxy/releases/download/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper xorg-macros

define $(PKG)_BUILD
     '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) -Dtests=false -Ddocs=false '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install

    $(SED) 's/Cflags:/Cflags: -DEPOXY_$(if $(BUILD_STATIC),STATIC,SHARED)/' \
        -i '$(PREFIX)/$(TARGET)/lib/pkgconfig/epoxy.pc'

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' epoxy --cflags --libs`
endef
