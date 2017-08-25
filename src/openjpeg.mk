# This file is part of MXE. See LICENSE.md for licensing information.
#Author: Julien Michel <julien.michel@orfeo-toolbox.org>

PKG             := openjpeg
$(PKG)_WEBSITE  := http://www.openjpeg.org/
$(PKG)_DESCR    := OpenJPEG
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.0
$(PKG)_CHECKSUM := 6fddbce5a618e910e03ad00d66e7fcd09cc6ee307ce69932666d54c73b7c6e7b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/uclouvain/openjpeg/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc lcms libpng tiff zlib

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
