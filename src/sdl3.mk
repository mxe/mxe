# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl3
$(PKG)_WEBSITE  := https://www.libsdl.org/
$(PKG)_DESCR    := SDL3
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.26
$(PKG)_SUBDIR   := SDL3-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL3-$($(PKG)_VERSION).tar.gz
$(PKG)_CHECKSUM := dad488474a51a0b01d547cd2834893d6299328d2e30f479a3564088b5476bae2
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
