# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cminpack
$(PKG)_WEBSITE  := http://devernay.free.fr/hacks/cminpack/cminpack.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.11
$(PKG)_CHECKSUM := 45675fac0a721a1c7600a91a9842fe1ab313069db163538f2923eaeddb0f46de
$(PKG)_GH_CONF  := devernay/cminpack/tags, v
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_BUILD_STATIC
    cd '$(1)' && '$(TARGET)-cmake'
    $(MAKE) -C '$(1)' -j $(JOBS)

    $(INSTALL) -d                         '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libcminpack.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d                         '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/cminpack.h'    '$(PREFIX)/$(TARGET)/include/'
endef

define $(PKG)_BUILD_SHARED
    cd '$(1)' && '$(TARGET)-cmake' -DUSE_FPIC=ON -DSHARED_LIBS=ON -DBUILD_EXAMPLES=OFF
    $(MAKE) -C '$(1)' -j $(JOBS)

    $(INSTALL) -d                             '$(PREFIX)/$(TARGET)/bin'
    $(INSTALL) -m644 '$(1)/libcminpack.dll'   '$(PREFIX)/$(TARGET)/bin/'
    $(INSTALL) -d                             '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libcminpack.dll.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d                             '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/cminpack.h'        '$(PREFIX)/$(TARGET)/include/'
endef
