# This file is part of MXE.
# See index.html for further information.

PKG             := yaml-cpp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.5.3
$(PKG)_CHECKSUM := ac50a27a201d16dc69a881b80ad39a7be66c4d755eda1f76c3a68781b922af8f
$(PKG)_SUBDIR   := $(PKG)-release-$($(PKG)_VERSION)
$(PKG)_FILE     := release-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/jbeder/yaml-cpp/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_SHARED_LIBS=$(if $(BUILD_STATIC),OFF,ON)

    $(MAKE) -C '$(1)' -j $(JOBS) VERBOSE=1
    $(MAKE) -C '$(1)' -j $(JOBS) install
endef
