# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := wavpack
$(PKG)_WEBSITE  := http://www.wavpack.com/
$(PKG)_DESCR    := WavPack
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.3.0
$(PKG)_CHECKSUM := b6f00b3a2185a1d2df6cf8d893ec60fd645d2eb90db7428a617fd27c9e8a6a01
$(PKG)_SUBDIR   := wavpack-$($(PKG)_VERSION)
$(PKG)_FILE     := wavpack-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.wavpack.com/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.wavpack.com/downloads.html' | \
    grep '<a href="wavpack-.*\.tar\.bz2">' | \
    head -n 1 | \
    $(SED) -e 's/^.*<a href="wavpack-\([0-9.]*\)\.tar\.bz2">.*$$/\1/'
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
         $(MXE_CONFIGURE_OPTS) \
        --without-iconv \
        CFLAGS="-DWIN32"
    $(MAKE) -C '$(1)' -j '$(JOBS)' SUBDIRS="src include"
    $(MAKE) -C '$(1)' -j 1 install SUBDIRS="src include"
endef
