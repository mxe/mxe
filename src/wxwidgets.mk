# wxWidgets
# http://www.wxwidgets.org/

PKG            := wxwidgets
$(PKG)_VERSION := 2.8.9
$(PKG)_SUBDIR  := wxMSW-$($(PKG)_VERSION)
$(PKG)_FILE    := wxMSW-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL     := http://$(SOURCEFORGE_MIRROR)/wxwindows/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc libiconv libpng jpeg tiff sdl tre zlib expat

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=9863&package_id=14078' | \
    grep 'wxMSW-' | \
    $(SED) -n 's,.*wxMSW-\([2-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-compat24 \
        --enable-stl \
        --enable-unicode \
        --with-themes=all \
        --with-msw \
        --with-opengl \
        --with-libpng=sys \
        --with-libjpeg=sys \
        --with-libtiff=sys \
        --with-regex=sys \
        --with-zlib=sys \
        --with-expat=sys \
        --with-sdl \
        --without-gtk \
        --without-motif \
        --without-mac \
        --without-macosx-sdk \
        --without-cocoa \
        --without-wine \
        --without-pm \
        --without-mgl \
        --without-directfb \
        --without-microwin \
        --without-x11 \
        --without-libxpm \
        --without-libmspack \
        --without-gnomeprint \
        --without-gnomevfs \
        --without-hildon \
        --without-dmalloc \
        --without-odbc \
        CFLAGS="-I$(PREFIX)/$(TARGET)/include/tre" \
        CXXFLAGS="-I$(PREFIX)/$(TARGET)/include/tre" \
        LIBS=" `$(TARGET)-pkg-config tre --libs`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
