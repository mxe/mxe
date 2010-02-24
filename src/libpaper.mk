# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libpaper
PKG             := libpaper
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.23+nmu1
$(PKG)_CHECKSUM := 9091fc346845585ceff105c887f35012c3a39e2b
$(PKG)_SUBDIR   := libpaper-$($(PKG)_VERSION)
$(PKG)_FILE     := libpaper_$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://packages.debian.org/unstable/libpaper1
$(PKG)_URL      := http://ftp.debian.org/debian/pool/main/libp/libpaper/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://packages.debian.org/unstable/source/libpaper' | \
    $(SED) -n 's,.*libpaper_\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
