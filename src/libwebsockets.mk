# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libwebsockets
$(PKG)_WEBSITE  := https://libwebsockets.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4-chrome43-firefox-36
$(PKG)_CHECKSUM := e11492477e582ef0b1a6ea2f18d81a9619b449170a3a5c43f32a9468461a9798
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/warmcat/libwebsockets/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc openssl zlib

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, warmcat/libwebsockets, \(v\|.[^0-9].*\))
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(TARGET)-cmake' \
        -DLWS_WITHOUT_TESTAPPS=ON \
        -DLWS_USE_EXTERNAL_ZLIB=ON
    $(MAKE) -C '$(1)' -j $(JOBS)
    $(MAKE) -C '$(1)' install
endef
