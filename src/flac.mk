# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := flac
$(PKG)_WEBSITE  := https://www.xiph.org/flac/
$(PKG)_DESCR    := FLAC
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.0
$(PKG)_CHECKSUM := af41c0733c93c237c3e52f64dd87e3b0d9af38259f1c7d11e8cbf583c48c2506
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
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-doxygen-docs \
        --disable-xmms-plugin \
        --enable-cpplibs \
        --enable-ogg \
        --disable-oggtest
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
