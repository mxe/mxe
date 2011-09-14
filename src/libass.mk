# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libass
PKG             := libass
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.13
$(PKG)_CHECKSUM := 05e210bd081af3e542778bd3a687724547fcd2ca
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.xz
$(PKG)_WEBSITE  := http://code.google.com/p/libass/
$(PKG)_URL      := http://libass.googlecode.com/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc freetype fontconfig

define $(PKG)_UPDATE
    wget -q -O- 'http://code.google.com/p/libass/downloads/list?sort=-uploaded' | \
    $(SED) -n 's,.*libass-\([0-9][^<]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-png \
        --disable-enca \
        --enable-fontconfig
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libass.exe' \
        `'$(TARGET)-pkg-config' libass --cflags --libs`
endef
