# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libass
$(PKG)_WEBSITE  := https://code.google.com/p/libass/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.17.4
$(PKG)_CHECKSUM := a886b3b80867f437bc55cff3280a652bfa0d37b43d2aff39ddf3c4f288b8c5a8
$(PKG)_GH_CONF  := libass/libass/releases
$(PKG)_DEPS     := cc fontconfig freetype fribidi harfbuzz $(BUILD)~nasm

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
