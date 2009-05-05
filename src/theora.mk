# Theora

PKG             := theora
$(PKG)_VERSION  := 1.0
$(PKG)_CHECKSUM := 70d1195a706a06520f96f5eda9b65e0587151830
$(PKG)_SUBDIR   := libtheora-$($(PKG)_VERSION)
$(PKG)_FILE     := libtheora-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://theora.org/
$(PKG)_URL      := http://downloads.xiph.org/releases/theora/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc ogg vorbis

define $(PKG)_UPDATE
    wget -q -O- 'http://www.xiph.org/downloads/' | \
    $(SED) -n 's,.*libtheora-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) 's,cross_compiling=no,cross_compiling=yes,' -i '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
