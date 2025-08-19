# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := frei0r-plugins
$(PKG)_VERSION  := 1.6.1
$(PKG)_CHECKSUM := e0c24630961195d9bd65aa8d43732469e8248e8918faa942cfb881769d11515e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_HOME     := https://files.dyne.org/frei0r/releases/
$(PKG)_URL      := $($(PKG)_HOME)/$($(PKG)_FILE)
$(PKG)_DEPS     := cairo

define $(PKG)_UPDATE
    $(WGET) -q -O-  https://files.dyne.org/frei0r/releases | \
    $(SED) -n 's,.*frei0r-plugins_\([0-9][^>]*\)\.tar.gz,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(1)/build-mxe'
    cd '$(1)/build-mxe' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DWITHOUT_GAVL=1 -DWITHOUT_OPENCV=1
    $(MAKE) -C '$(1)/build-mxe' -j '$(JOBS)' install
endef
