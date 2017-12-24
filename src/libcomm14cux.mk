# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libcomm14cux
$(PKG)_WEBSITE  := https://github.com/colinbourassa/libcomm14cux/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.1
$(PKG)_CHECKSUM := 4b3d0969e2226a0f3c1250c609858e487631507ed62bf6732ce82f13f0d9fcc9
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/colinbourassa/libcomm14cux/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && '$(TARGET)-cmake' ..

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef
