# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := chromaprint
$(PKG)_WEBSITE  := https://acoustid.org/chromaprint
$(PKG)_DESCR    := Chromaprint
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5.0
$(PKG)_CHECKSUM := 5c8e0d579cb3478900699110aa961c1552a422a18741cf67dd62136b1b877c7b
$(PKG)_GH_CONF  := acoustid/chromaprint/tags, v
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc ffmpeg

define $(PKG)_BUILD
    cd '$(1)' && '$(TARGET)-cmake'
    $(MAKE) -C '$(1)' -j 1 install
endef
