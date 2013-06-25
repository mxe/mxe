# This file is part of MXE.
# See index.html for further information.

PKG             := sdl2
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := ff1853d589ad2974e43154e977ed554f71a5a9d2
$(PKG)_SUBDIR   := SDL2-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL2-$($(PKG)_VERSION).tar.gz
#$(PKG)_URL      := http://www.libsdl.org/release/$($(PKG)_FILE)
$(PKG)_URL      := http://www.libsdl.org/tmp/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://hg.libsdl.org/SDL/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,-mwindows,-lwinmm -mwindows,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-threads \
        --enable-directx
    $(SED) -i 's,-XCClinker,,' '$(1)/sdl2.pc'
    $(SED) -i 's,-XCClinker,,' '$(1)/sdl2-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    ln -sf '$(PREFIX)/$(TARGET)/bin/sdl2-config' '$(PREFIX)/bin/$(TARGET)-sdl2-config'
endef

$(PKG)_BUILD_i686-pc-mingw32 =
