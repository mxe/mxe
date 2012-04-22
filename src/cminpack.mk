# This file is part of MXE.
# See index.html for further information.

PKG             := cminpack
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 7a89a0c5c09585823ca4b11bc3eddb13df3fd0c3
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://devernay.free.fr/hacks/cminpack/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc cmake

define $(PKG)_UPDATE
    echo 1
endef

define $(PKG)_BUILD
    echo "src/cminpack.mk is experimental"
    make 
	
    $(INSTALL) -d                           '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libcminpack.a'      '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d                           '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/include/cminpack.h'     '$(PREFIX)/$(TARGET)/include/'
endef
