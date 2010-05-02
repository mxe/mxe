# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libshout
PKG             := libshout
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.2
$(PKG)_CHECKSUM := cabc409e63f55383f4d85fac26d3056bf0365aac
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.icecast.org/
$(PKG)_URL      := http://downloads.us.xiph.org/releases/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc vorbis ogg theora speex

define $(PKG)_UPDATE
    wget -q -O- 'http://www.icecast.org/download.php' | \
    $(SED) -n 's,.*libshout-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-debug \
        --disable-thread \
        --infodir='$(1)/sink' \
        --mandir='$(1)/sink'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
