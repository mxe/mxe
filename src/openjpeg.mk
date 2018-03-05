# This file is part of MXE. See LICENSE.md for licensing information.
#Author: Julien Michel <julien.michel@orfeo-toolbox.org>

PKG             := openjpeg
$(PKG)_WEBSITE  := http://www.openjpeg.org/
$(PKG)_DESCR    := OpenJPEG
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.0
$(PKG)_CHECKSUM := 3dc787c1bb6023ba846c2a0d9b1f6e179f1cd255172bde9eb75b01f1e6c7d71a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/uclouvain/openjpeg/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc lcms libpng tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://api.github.com/repos/uclouvain/openjpeg/git/refs/tags/' | \
    $(SED) -n 's#.*"ref": "refs/tags/v\([0-9,.]*\).*#\1#p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(TARGET)-cmake' \
        -DBUILD_TESTING=FALSE \
        '$(1)'
    $(MAKE) -C '$(1).build' install
endef
