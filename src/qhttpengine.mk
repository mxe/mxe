# This file is part of MXE.
# See index.html for further information.

PKG             := qhttpengine
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.0
$(PKG)_CHECKSUM := 6df0e2f303eb5fb80995e0322903c2991b398a0b89fb483dae7c24bdefa1eaf1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/nitroshare/qhttpengine/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_STATIC=$(if $(BUILD_STATIC),ON,OFF)

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef
