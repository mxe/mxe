# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qhttpengine
$(PKG)_WEBSITE  := https://github.com/nitroshare/qhttpengine
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.0
$(PKG)_CHECKSUM := 6df0e2f303eb5fb80995e0322903c2991b398a0b89fb483dae7c24bdefa1eaf1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/nitroshare/qhttpengine/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc qtbase

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && '$(TARGET)-cmake' ..

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef
