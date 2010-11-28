# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Vorbis
PKG             := vorbis
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.2
$(PKG)_CHECKSUM := 4b089ace4c8420c479b2fde9c5b01588cf86c959
$(PKG)_SUBDIR   := libvorbis-$($(PKG)_VERSION)
$(PKG)_FILE     := libvorbis-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.vorbis.com/
$(PKG)_URL      := http://downloads.xiph.org/releases/vorbis/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc ogg

define $(PKG)_UPDATE
    wget -q -O- 'http://www.xiph.org/downloads/' | \
    $(SED) -n 's,.*libvorbis-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
