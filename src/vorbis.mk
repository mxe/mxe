# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# Vorbis
PKG             := vorbis
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.3
$(PKG)_CHECKSUM := a93251aa5e4f142db4fa6433de80797f80960fac
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
        PKG_CONFIG='$(TARGET)-pkg-config' \
        LIBS='-lws2_32'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
