# This file is part of MXE.
# See index.html for further information.

PKG             := tre
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.0
$(PKG)_CHECKSUM := 8818058785923c32f5e1f48feeb2851507c0e61c
$(PKG)_SUBDIR   := tre-$($(PKG)_VERSION)
$(PKG)_FILE     := tre-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://laurikari.net/tre/$($(PKG)_FILE)
$(PKG)_URL_2    := http://ftp.debian.org/debian/pool/main/t/$(PKG)/$(PKG)_$($(PKG)_VERSION).orig.tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://laurikari.net/tre/download.html' | \
    $(SED) -n 's,.*tre-\([a-z0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-nls
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_SHARED =
