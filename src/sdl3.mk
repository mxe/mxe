# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl3
$(PKG)_WEBSITE  := https://www.libsdl.org/
$(PKG)_DESCR    := SDL3
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.0
$(PKG)_SUBDIR   := SDL3-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL3-$($(PKG)_VERSION).tar.gz
$(PKG)_CHECKSUM := 082cbf5f429e0d80820f68dc2b507a94d4cc1b4e70817b119bbb8ec6a69584b8
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
