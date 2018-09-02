# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := chromaprint
$(PKG)_WEBSITE  := https://acoustid.org/chromaprint
$(PKG)_DESCR    := Chromaprint
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.3
$(PKG)_CHECKSUM := d4ae6596283aad7a015a5b0445012054c634a4b9329ecb23000cd354b40a283b
$(PKG)_GH_CONF  := acoustid/chromaprint/tags, v
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc fftw

define $(PKG)_BUILD
    cd '$(1)' && '$(TARGET)-cmake'
    $(MAKE) -C '$(1)' -j 1 install
endef
