# This file is part of MXE.
# See index.html for further information.

PKG             := libshout
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.1
$(PKG)_CHECKSUM := 147c5670939727420d0e2ad6a20468e2c2db1e20
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.us.xiph.org/releases/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc vorbis ogg theora speex

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.icecast.org/download.php' | \
    $(SED) -n 's,.*libshout-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-thread \
        --infodir='$(1)/sink' \
        --mandir='$(1)/sink'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef

$(PKG)_BUILD_SHARED =
