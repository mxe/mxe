# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libass
$(PKG)_WEBSITE  := https://code.google.com/p/libass/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.17.1
$(PKG)_CHECKSUM := 5ba42655d7e8c5e87bba3ffc8a2b1bc19c29904240126bb0d4b924f39429219f
$(PKG)_GH_CONF  := libass/libass/releases/latest
$(PKG)_DEPS     := cc fontconfig freetype fribidi harfbuzz

define $(PKG)_BUILD
    # fontconfig is only required for legacy XP support
    cd '$(SOURCE_DIR)' && ./autogen.sh
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
