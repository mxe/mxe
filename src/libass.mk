# This file is part of MXE.
# See index.html for further information.

PKG             := libass
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.13.0
$(PKG)_CHECKSUM := e0071a3b2e95411c8d474014678368e3f0b852f7d663e0564b344e7335eb0671
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.xz
$(PKG)_URL      := https://github.com/libass/libass/releases/download/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc fontconfig freetype fribidi harfbuzz

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://code.google.com/p/libass/downloads/list?sort=-uploaded' | \
    $(SED) -n 's,.*libass-\([0-9][^<]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # fontconfig is only required for legacy XP support
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-enca \
        --enable-fontconfig \
        --enable-harfbuzz
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libass.exe' \
        `'$(TARGET)-pkg-config' libass --cflags --libs`
endef
