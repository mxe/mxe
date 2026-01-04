# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := flac
$(PKG)_WEBSITE  := https://www.xiph.org/flac/
$(PKG)_DESCR    := Free Lossless Audio Codec
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5.0
$(PKG)_CHECKSUM := f2c1c76592a82ffff8413ba3c4a1299b6c7ab06c734dee03fd88630485c2b920
$(PKG)_SUBDIR   := flac-$($(PKG)_VERSION)
$(PKG)_FILE     := flac-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://downloads.xiph.org/releases/flac/$($(PKG)_FILE)
$(PKG)_DEPS     := cc ogg $(BUILD)~nasm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://downloads.xiph.org/releases/flac/' | \
    $(SED) -n 's,.*<a href="flac-\([0-9][0-9.]*\)\.tar\.[gx]z">.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh
    $(if $(BUILD_STATIC), \
        $(SED) -i 's/^\(Cflags:.*\)/\1 -DFLAC__NO_DLL/' \
            '$(1)/src/libFLAC/flac.pc.in' \
            '$(1)/src/libFLAC++/flac++.pc.in',)
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-doxygen-docs \
        --disable-examples \
        --disable-xmms-plugin \
        --enable-cpplibs \
        --enable-ogg \
        --disable-oggtest
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
