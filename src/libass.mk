# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libass
$(PKG)_WEBSITE  := https://code.google.com/p/libass/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.13.7
$(PKG)_CHECKSUM := 7065e5f5fb76e46f2042a62e7c68d81e5482dbeeda24644db1bd066e44da7e9d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.xz
$(PKG)_URL      := https://github.com/libass/libass/releases/download/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc fontconfig freetype fribidi harfbuzz

define $(PKG)_UPDATE
    $(WGET) -q -O- "https://api.github.com/repos/libass/libass/releases" | \
    $(SED) -n '/tag_name/ s,.*tag_name": "\([0-9][^>]*\)".*,\1,p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && $(LIBTOOLIZE)
    # fontconfig is only required for legacy XP support
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-fontconfig \
        --enable-harfbuzz
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libass.exe' \
        `'$(TARGET)-pkg-config' libass --cflags --libs`
endef
