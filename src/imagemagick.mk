# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := imagemagick
$(PKG)_WEBSITE  := https://www.imagemagick.org/
$(PKG)_DESCR    := ImageMagick
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.1.2-16
$(PKG)_CHECKSUM := aadfa67a104d14a35339de0f2cc286c973a0f43329770c69e9667a22208750fb
$(PKG)_GH_CONF  := ImageMagick/ImageMagick/tags
$(PKG)_DEPS     := cc bzip2 ffmpeg fftw freetype jpeg lcms liblqr-1 libltdl \
                   libpng libraw openexr openjpeg pthreads tiff zlib

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --with-x=no \
        --disable-largefile \
        --with-freetype='$(PREFIX)/$(TARGET)/bin/freetype-config'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' bin_PROGRAMS=
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install bin_PROGRAMS=

    '$(TARGET)-g++' -Wall -Wextra -std=gnu++0x \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-imagemagick.exe' \
        `'$(TARGET)-pkg-config' Magick++ --cflags --libs`
endef
