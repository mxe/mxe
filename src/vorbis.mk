# This file is part of MXE.
# See index.html for further information.

PKG             := vorbis
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.4
$(PKG)_CHECKSUM := 1602716c187593ffe4302124535240cec2079df3
$(PKG)_SUBDIR   := libvorbis-$($(PKG)_VERSION)
$(PKG)_FILE     := libvorbis-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.xiph.org/releases/vorbis/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc ogg

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.xiph.org/downloads/' | \
    $(SED) -n 's,.*libvorbis-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
