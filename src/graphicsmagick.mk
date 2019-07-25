# This file is part of MXE.
# See index.html for further information.

PKG             := graphicsmagick
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
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
         $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-openmp \
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
       --with-quantum-depth=16 \
        ac_cv_prog_xml2_config='$(PREFIX)/$(TARGET)/bin/xml2-config' \
        ac_cv_path_xml2_config='$(PREFIX)/$(TARGET)/bin/xml2-config' \

    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= DESTDIR='$(3)'

    if [ "$(ENABLE_DEP_DOCS)" == "no" ]; then \
      rm -rf "$(3)$(PREFIX)/$(TARGET)/share/doc/GraphicsMagick"; \
    fi
endef
