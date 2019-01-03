# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := vorbis
$(PKG)_WEBSITE  := https://xiph.org/vorbis/
$(PKG)_DESCR    := Vorbis
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.6
$(PKG)_CHECKSUM := 6ed40e0241089a42c48604dc00e362beee00036af2d8b3f46338031c9e0351cb
$(PKG)_SUBDIR   := libvorbis-$($(PKG)_VERSION)
$(PKG)_FILE     := libvorbis-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://downloads.xiph.org/releases/vorbis/$($(PKG)_FILE)
$(PKG)_DEPS     := cc ogg

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.xiph.org/downloads/' | \
    $(SED) -n 's,.*libvorbis-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
