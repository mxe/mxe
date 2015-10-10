# This file is part of MXE.
# See index.html for further information.

PKG             := libcomm14cux
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.0
$(PKG)_CHECKSUM := 579c34b529600debd4a4216959e583fac5836d878de2bf2bec1115c4567d4623
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/colinbourassa/libcomm14cux/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_STATIC=$(if $(BUILD_STATIC),ON,OFF)

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef
