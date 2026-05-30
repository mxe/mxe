# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl2
$(PKG)_WEBSITE  := https://www.libsdl.org/
$(PKG)_DESCR    := SDL2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.32.10
$(PKG)_SUBDIR   := SDL2-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL2-$($(PKG)_VERSION).tar.gz
$(PKG)_CHECKSUM := 5f5993c530f084535c65a6879e9b26ad441169b3e25d789d83287040a9ca5165
$(PKG)_GH_CONF  := libsdl-org/SDL/releases/tag,release-,,
define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://api.github.com/repos/libsdl-org/SDL/releases' | \
    $(SED) -n 's,.*"tag_name": "release-\(2\.[0-9][^"]*\)".*,\1,p' | \
    $(SORT) -Vr | \
    head -1
endef
$(PKG)_DEPS     := cc libiconv libsamplerate

define $(PKG)_BUILD
    cd '$(1)' && aclocal -I acinclude && autoconf && $(SHELL) ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads \
        --enable-directx \
        --enable-libsamplerate \
        --enable-libsamplerate-shared=$(if $(BUILD_SHARED),yes,no) \
        CFLAGS='-std=gnu99'
    $(SED) -i 's,defined(__MINGW64_VERSION_MAJOR),defined(__MINGW64_VERSION_MAJOR) \&\& defined(_WIN64),' '$(1)/include/SDL_cpuinfo.h'
    $(SED) -i 's,-XCClinker,,' '$(1)/sdl2.pc'
    $(SED) -i 's,-XCClinker,,' '$(1)/sdl2-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' SHELL=$(SHELL)
    $(MAKE) -C '$(1)' -j 1 install SHELL=$(SHELL)
    ln -sf '$(PREFIX)/$(TARGET)/bin/sdl2-config' '$(PREFIX)/bin/$(TARGET)-sdl2-config'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-sdl2.exe' \
        `'$(TARGET)-pkg-config' sdl2 --cflags --libs`

endef
