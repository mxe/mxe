# This file is part of MXE.
# See index.html for further information.

PKG             := libwebsockets
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.2
$(PKG)_CHECKSUM := 43865604debd06686ac4d8d0783976c4e10dd519ccd5c94e1b53878ec6178a59
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/warmcat/libwebsockets/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc openssl zlib

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, warmcat/libwebsockets, \(v\|.[^0-9].*\))
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        -DLWS_WITHOUT_TESTAPPS=ON \
        -DLWS_USE_EXTERNAL_ZLIB=ON \
        -DLWS_WITH_STATIC=$(CMAKE_STATIC_BOOL) \
        -DLWS_WITH_SHARED=$(CMAKE_SHARED_BOOL) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'
    $(MAKE) -C '$(1)' -j $(JOBS)
    $(MAKE) -C '$(1)' install
endef
