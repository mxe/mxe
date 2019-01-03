# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libbluray
$(PKG)_WEBSITE  := https://www.videolan.org/developers/libbluray.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.2
$(PKG)_CHECKSUM := efc994f42d2bce6af2ce69d05ba89dbbd88bcec7aca065de094fb3a7880ce7ea
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.bz2
$(PKG)_URL      := https://download.videolan.org/pub/videolan/libbluray/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc freetype libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.videolan.org/pub/videolan/libbluray/' | \
    $(SED) -n 's,<a href="\([0-9][^<]*\)/".*,\1,p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-examples \
        --with-freetype \
        --with-libxml2 \
        --disable-bdjava
    $(MAKE) -C '$(1)' -j '$(JOBS)' LDFLAGS='-no-undefined'
    $(MAKE) -C '$(1)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(1)/src/examples/sound_dump.c' -o '$(PREFIX)/$(TARGET)/bin/test-libbluray.exe' \
        `'$(TARGET)-pkg-config' libbluray --cflags --libs`
endef
