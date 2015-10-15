# This file is part of MXE.
# See index.html for further information.

PKG             := sdl2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.3
$(PKG)_CHECKSUM := a5a69a6abf80bcce713fa873607735fe712f44276a7f048d60a61bb2f6b3c90c
$(PKG)_SUBDIR   := SDL2-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libsdl.org/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://hg.libsdl.org/SDL/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && aclocal -I acinclude && autoconf && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads \
        --enable-directx
    $(SED) -i 's,defined(__MINGW64_VERSION_MAJOR),defined(__MINGW64_VERSION_MAJOR) \&\& defined(_WIN64),' '$(1)/include/SDL_cpuinfo.h'
    $(SED) -i 's,-XCClinker,,' '$(1)/sdl2.pc'
    $(SED) -i 's,-XCClinker,,' '$(1)/sdl2-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    ln -sf '$(PREFIX)/$(TARGET)/bin/sdl2-config' '$(PREFIX)/bin/$(TARGET)-sdl2-config'
endef
