# This file is part of MXE.
# See index.html for further information.

PKG             := libshout
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.1
$(PKG)_CHECKSUM := cf3c5f6b4a5e3fcfbe09fb7024aa88ad4099a9945f7cb037ec06bcee7a23926e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.us.xiph.org/releases/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc ogg speex theora vorbis

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
