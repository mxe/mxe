# This file is part of MXE. See LICENSE.md for licensing information.
#Author: Julien Michel <julien.michel@orfeo-toolbox.org>

PKG             := openjpeg
$(PKG)_WEBSITE  := https://www.openjpeg.org/
$(PKG)_DESCR    := OpenJPEG
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5.3
$(PKG)_CHECKSUM := 368fe0468228e767433c9ebdea82ad9d801a3ad1e4234421f352c8b06e7aa707
$(PKG)_GH_CONF  := uclouvain/openjpeg/tags,v,,version
$(PKG)_DEPS     := cc lcms libpng tiff zlib

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_PKGCONFIG_FILES=ON \
        -DBUILD_TESTING=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' -Wall -Wextra \
        '$(SOURCE_DIR)/tests/unit/testempty1.c' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' libopenjp2 --cflags --libs`
endef
