# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := chromaprint
$(PKG)_WEBSITE  := https://acoustid.org/chromaprint
$(PKG)_DESCR    := Chromaprint
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.3
$(PKG)_CHECKSUM := ea18608b76fb88e0203b7d3e1833fb125ce9bb61efe22c6e169a50c52c457f82
$(PKG)_SUBDIR   := $(PKG)-v$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/acoustid/chromaprint/releases/download/v$($(PKG)_VERSION)/$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc fftw

define $(PKG)_UPDATE
    echo 'TODO: Updates for package chromaprint need to be written.' >&2;
    echo $(chromaprint_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(TARGET)-cmake'
    $(MAKE) -C '$(1)' -j 1 install
endef
