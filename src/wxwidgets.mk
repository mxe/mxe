# wxWidgets

PKG            := wxwidgets
$(PKG)_VERSION := 2.8.9
$(PKG)_SUBDIR  := wxMSW-$($(PKG)_VERSION)
$(PKG)_FILE    := wxMSW-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE := http://www.wxwidgets.org/
$(PKG)_URL     := http://$(SOURCEFORGE_MIRROR)/wxwindows/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc libiconv libpng jpeg tiff sdl tre zlib expat

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=9863&package_id=14078' | \
    grep 'wxMSW-' | \
    $(SED) -n 's,.*wxMSW-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,wx_cv_cflags_mthread=yes,wx_cv_cflags_mthread=no,' -i '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-compat24 \
        --enable-compat26 \
        --enable-gui \
        --enable-stl \
        --enable-threads \
        --enable-unicode \
        --disable-universal \
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
        --without-microwin \
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
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= __install_wxrc___depname=
    install -m755 '$(PREFIX)/$(TARGET)/bin/wx-config' '$(PREFIX)/bin/$(TARGET)-wx-config'

    # build the wxWidgets variant without unicode support
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,wxwidgets)
    $(SED) 's,wx_cv_cflags_mthread=yes,wx_cv_cflags_mthread=no,' -i '$(1)/$(wxwidgets_SUBDIR)/configure'
    cd '$(1)/$(wxwidgets_SUBDIR)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-compat24 \
        --enable-compat26 \
        --enable-gui \
        --enable-stl \
        --enable-threads \
        --disable-unicode \
        --disable-universal \
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
        --without-microwin \
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
    $(MAKE) -C '$(1)/$(wxwidgets_SUBDIR)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    # backup of the unicode wx-config script
    # such that "make install" won't overwrite it
    mv '$(PREFIX)/$(TARGET)/bin/wx-config' '$(PREFIX)/$(TARGET)/bin/wx-config-backup'

    $(MAKE) -C '$(1)/$(wxwidgets_SUBDIR)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= __install_wxrc___depname=
    mv '$(PREFIX)/$(TARGET)/bin/wx-config' '$(PREFIX)/$(TARGET)/bin/wx-config-nounicode'
    install -m755 '$(PREFIX)/$(TARGET)/bin/wx-config-nounicode' '$(PREFIX)/bin/$(TARGET)-wx-config-nounicode'

    # restore the unicode wx-config script
    mv '$(PREFIX)/$(TARGET)/bin/wx-config-backup' '$(PREFIX)/$(TARGET)/bin/wx-config'
endef
