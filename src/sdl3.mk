# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl3
$(PKG)_WEBSITE  := https://www.libsdl.org/
$(PKG)_DESCR    := SDL3
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.2
$(PKG)_SUBDIR   := SDL-release-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL3-$($(PKG)_VERSION).tar.gz
$(PKG)_CHECKSUM := d1339050e89475464a8997aae2570b3b78577a4642af5815fd8855fa4cc3c8ca
$(PKG)_GH_CONF  := libsdl-org/SDL/releases/tag,release-,,
$(PKG)_DEPS     := cc libiconv libsamplerate

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DSDL_SHARED=$(CMAKE_SHARED_BOOL) \
        -DSDL_STATIC=$(CMAKE_STATIC_BOOL) \
        -DVERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-sdl3.exe' \
        `'$(TARGET)-pkg-config' sdl3 --cflags --libs`

endef
