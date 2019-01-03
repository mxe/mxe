# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := tre
$(PKG)_WEBSITE  := https://laurikari.net/tre/
$(PKG)_DESCR    := TRE
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.0
$(PKG)_CHECKSUM := be8670a55198bc57485a6a8ae4b497d7db98ea25f90968585b7eb07d94c6a7dd
$(PKG)_SUBDIR   := tre-$($(PKG)_VERSION)
$(PKG)_FILE     := tre-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://laurikari.net/tre/$($(PKG)_FILE)
$(PKG)_URL_2    := https://deb.debian.org/debian/pool/main/t/$(PKG)/$(PKG)_$($(PKG)_VERSION).orig.tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://laurikari.net/tre/download.html' | \
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
