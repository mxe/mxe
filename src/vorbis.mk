# Vorbis

PKG             := vorbis
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := 6ff5f9d9d71cc385ee180171cc21af5653b76a16
$(PKG)_SUBDIR   := libvorbis-$($(PKG)_VERSION)
$(PKG)_FILE     := libvorbis-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.vorbis.com/
$(PKG)_URL      := http://downloads.xiph.org/releases/vorbis/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pthreads ogg

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
