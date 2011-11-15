# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# SDL
PKG             := sdl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.14
$(PKG)_CHECKSUM := ba625b4b404589b97e92d7acd165992debe576dd
$(PKG)_SUBDIR   := SDL-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.libsdl.org/
$(PKG)_URL      := http://www.libsdl.org/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv

define $(PKG)_UPDATE
    wget -q -O- 'http://www.libsdl.org/cgi/viewvc.cgi/tags/SDL/?sortby=date' | \
    grep '<a name="' | \
    $(SED) -n 's,.*<a name="release-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,-mwindows,-lwinmm -mwindows,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-threads \
        --enable-directx \
        --disable-stdio-redirect
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    ln -sf '$(PREFIX)/$(TARGET)/bin/sdl-config' '$(PREFIX)/bin/$(TARGET)-sdl-config'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl.exe' \
        `'$(TARGET)-pkg-config' sdl --cflags --libs`
endef
