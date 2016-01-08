# This file is part of MXE.
# See index.html for further information.

PKG             := box2d
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.1
$(PKG)_CHECKSUM := 2c61505f03ef403b54cf0e510d83d6f567e37882ad79b5b2d486acbc7d5eedea
$(PKG)_SUBDIR   := Box2D-$($(PKG)_VERSION)/Box2D
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/erincatto/Box2D/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, erincatto/Box2D) | \
    $(SED) 's,^v,,g'
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBOX2D_INSTALL=ON \
        -DBOX2D_BUILD_EXAMPLES=OFF \
        -DBOX2D_BUILD_STATIC=$(CMAKE_STATIC_BOOL) \
        -DBOX2D_BUILD_SHARED=$(CMAKE_SHARED_BOOL) \
        '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' install VERBOSE=1
endef
