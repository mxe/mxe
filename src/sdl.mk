# This file is part of MXE.
# See index.html for further information.

PKG             := sdl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.15
$(PKG)_CHECKSUM := d6d316a793e5e348155f0dd93b979798933fb98aa1edebcc108829d6474aad00
$(PKG)_SUBDIR   := SDL-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libsdl.org/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://hg.libsdl.org/SDL/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    grep '^1\.' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,-mwindows,-lwinmm -mwindows,' '$(1)/configure'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads \
        --enable-directx \
        --disable-stdio-redirect
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install-bin install-hdrs install-lib install-data
    ln -sf '$(PREFIX)/$(TARGET)/bin/sdl-config' '$(PREFIX)/bin/$(TARGET)-sdl-config'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl.exe' \
        `'$(TARGET)-pkg-config' sdl --cflags --libs`

    # test cmake
    mkdir '$(1).test-cmake'
    cd '$(1).test-cmake' && '$(TARGET)-cmake' \
        -DPKG=$(PKG) \
        -DPKG_VERSION=$($(PKG)_VERSION) \
        '$(PWD)/src/cmake/test'
    $(MAKE) -C '$(1).test-cmake' -j 1 install
endef
