# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libshout
$(PKG)_WEBSITE  := https://icecast.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.6
$(PKG)_CHECKSUM := 39cbd4f0efdfddc9755d88217e47f8f2d7108fa767f9d58a2ba26a16d8f7c910
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://downloads.xiph.org/releases/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc ogg openssl speex theora vorbis

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://icecast.org/download/' | \
    $(SED) -n 's,.*libshout-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # doesn't support out-of-tree builds
    cd '$(SOURCE_DIR)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        ac_cv_prog_PKGCONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        --disable-thread \
        CFLAGS='-std=gnu89'
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(SOURCE_DIR)' -j 1 install
endef

$(PKG)_BUILD_SHARED =
