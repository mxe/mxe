# This file is part of MXE.
# See index.html for further information.

PKG             := libpaper
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.24+nmu2
$(PKG)_CHECKSUM := 40f16453d7752bf5e3c9e74515650eb37edbb3fe
$(PKG)_SUBDIR   := libpaper-$($(PKG)_VERSION)
$(PKG)_FILE     := libpaper_$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.debian.org/debian/pool/main/libp/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := http://linux.mirrors.es.net/pub/ubuntu/pool/main/libp/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://packages.debian.org/unstable/source/libpaper' | \
    $(SED) -n 's,.*libpaper_\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_SHARED =
