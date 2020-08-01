# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := graphicsmagick
$(PKG)_WEBSITE  := http://www.graphicsmagick.org/
$(PKG)_DESCR    := GraphicsMagick
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.33
$(PKG)_CHECKSUM := ae86f749815d3039ac431caf9fc4b65acf32bfd140d1817644d3463b6ba9d51c
$(PKG)_SUBDIR   := GraphicsMagick-$($(PKG)_VERSION)
$(PKG)_FILE     := GraphicsMagick-$($(PKG)_VERSION).tar.lz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc bzip2 freetype jasper jpeg lcms libltdl libpng libxml2 pthreads tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/graphicsmagick/files/graphicsmagick/' | \
    $(SED) -n 's,.*/projects/.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # This can be removed once the patch "graphicsmagick-1-fix-xml2-config.patch" is accepted by upstream
    cd '$(SOURCE_DIR)' && autoconf
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
         $(MXE_CONFIGURE_OPTS) \
        --without-modules \
        --with-threads \
        --with-magick-plus-plus \
        --without-perl \
        --with-bzlib \
        --without-dps \
        --without-fpx \
        --without-gslib \
        --without-jbig \
        --with-jpeg \
        --with-jp2 \
        --with-lcms2 \
        --with-png \
        --with-tiff \
        --without-trio \
        --with-ttf='$(PREFIX)/$(TARGET)' \
        --without-wmf \
        --with-xml \
        --with-zlib \
        --without-x \
        ac_cv_prog_xml2_config='$(PREFIX)/$(TARGET)/bin/xml2-config' \
        ac_cv_path_xml2_config='$(PREFIX)/$(TARGET)/bin/xml2-config' \
        LIBS='-lgomp -fopenmp' \
        $(PKG_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' bin_PROGRAMS=
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install bin_PROGRAMS=

    '$(TARGET)-g++' \
        -W -Wall -Werror -pedantic -std=gnu++0x \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-graphicsmagick.exe' \
        `'$(TARGET)-pkg-config' GraphicsMagick++ --cflags --libs` -llzma
endef
