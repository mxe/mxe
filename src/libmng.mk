# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libmng
$(PKG)_WEBSITE  := https://www.libmng.com/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.3
$(PKG)_CHECKSUM := 4a462fdd48d4bc82c1d7a21106c8a18b62f8cc0042454323058e6da0dbb57dd3
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)-devel/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc jpeg lcms zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/libmng/files/libmng-devel/' | \
    $(SED) -n 's,.*/projects/.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    echo 'Requires: zlib lcms2 libjpeg' >> '$(1)/libmng.pc.in'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install LDFLAGS='-no-undefined'
endef
