# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libass
$(PKG)_WEBSITE  := https://code.google.com/p/libass/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.14.0
$(PKG)_CHECKSUM := 8d5a5c920b90b70a108007ffcd2289ac652c0e03fc88e6eecefa37df0f2e7fdf
$(PKG)_GH_CONF  := libass/libass/releases/latest
$(PKG)_DEPS     := cc fontconfig freetype fribidi harfbuzz

define $(PKG)_BUILD
    # fontconfig is only required for legacy XP support
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --enable-fontconfig \
        --enable-harfbuzz
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libass.exe' \
        `'$(TARGET)-pkg-config' libass --cflags --libs`
endef
