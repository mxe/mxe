# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libshout
$(PKG)_WEBSITE  := http://www.icecast.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.1
$(PKG)_CHECKSUM := f3acb8dec26f2dbf6df778888e0e429a4ce9378a9d461b02a7ccbf2991bbf24d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://downloads.xiph.org/releases/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc ogg openssl speex theora vorbis

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.icecast.org/download.php' | \
    $(SED) -n 's,.*libshout-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # doesn't support out-of-tree builds
    cd '$(SOURCE_DIR)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        ac_cv_prog_PKGCONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        --disable-thread
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(SOURCE_DIR)' -j 1 install
endef

$(PKG)_BUILD_SHARED =
