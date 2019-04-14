# This file is part of MXE. See LICENSE.md for licensing information.
#Author: Julien Michel <julien.michel@orfeo-toolbox.org>

PKG             := openjpeg
$(PKG)_WEBSITE  := https://www.openjpeg.org/
$(PKG)_DESCR    := OpenJPEG
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.1
$(PKG)_CHECKSUM := 63f5a4713ecafc86de51bfad89cc07bb788e9bba24ebbf0c4ca637621aadb6a9
$(PKG)_GH_CONF  := uclouvain/openjpeg/tags,v,,version
$(PKG)_DEPS     := cc lcms libpng tiff zlib

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_PKGCONFIG_FILES=ON \
        -DBUILD_TESTING=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
