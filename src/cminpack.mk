# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cminpack
$(PKG)_WEBSITE  := http://devernay.free.fr/hacks/cminpack/cminpack.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.4
$(PKG)_CHECKSUM := 3b517bf7dca68cc9a882883db96dac0a0d37d72aba6dfb0c9c7e78e67af503ca
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://devernay.free.fr/hacks/cminpack/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://devernay.free.fr/hacks/cminpack/index.html' | \
    $(SED) -n 's,.*cminpack-\([0-9.]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(TARGET)-cmake'
    $(MAKE) -C '$(1)' -j $(JOBS)

    $(INSTALL) -d                         '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libcminpack.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d                         '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/cminpack.h'    '$(PREFIX)/$(TARGET)/include/'
endef

$(PKG)_BUILD_SHARED =
