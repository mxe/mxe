# This file is part of MXE.
# See index.html for further information.

PKG             := qhttpengine
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.0
$(PKG)_CHECKSUM := 427d13e34606c1a4a5f0a74c76fc82e816d625aa
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
