# This file is part of MXE.
# See index.html for further information.
#Author: Julien Michel <julien.michel@orfeo-toolbox.org>

PKG             := openjpeg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.0
$(PKG)_CHECKSUM := 1232bb814fd88d8ed314c94f0bfebb03de8559583a33abbe8c64ef3fc0a8ff03
$(PKG)_SUBDIR   := openjpeg-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://sourceforge.net/projects/openjpeg.mirror/files/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc lcms libpng tiff zlib

#git commit 3d95bcf
define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/openjpeg.mirror/files/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_SHARED_LIBS=$(if $(BUILD_STATIC),FALSE,TRUE) \
        -DBUILD_TESTING=FALSE \
        '$(1)'
    $(MAKE) -C '$(1).build' install
endef
