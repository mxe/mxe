# This file is part of MXE.
# See index.html for further information.

PKG             := libbluray
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.7.0
$(PKG)_CHECKSUM := f79beb9fbb24117cbb1264c919e686ae9e6349c0ad08b48c4b6233b2887eb68d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.bz2
$(PKG)_URL      := http://ftp.videolan.org/pub/videolan/libbluray/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.videolan.org/pub/videolan/libbluray/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc freetype libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.videolan.org/pub/videolan/libbluray/' | \
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
