# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libepoxy
$(PKG)_WEBSITE  := https://github.com/anholt/libepoxy
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5.9
$(PKG)_CHECKSUM := d168a19a6edfdd9977fef1308ccf516079856a4275cf876de688fb7927e365e4
$(PKG)_GH_CONF  := anholt/libepoxy/releases/latest
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
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
