# Copyright (C) 2009  Volker Grabsch
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject
# to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# wxWidgets
PKG             := wxwidgets
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8.10
$(PKG)_CHECKSUM := e674086391ce5c8e64ef1823654d6f88b064c8e0
$(PKG)_SUBDIR   := wxMSW-$($(PKG)_VERSION)
$(PKG)_FILE     := wxMSW-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.wxwidgets.org/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/wxwindows/wxMSW/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv libpng jpeg tiff sdl zlib expat

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/wxwindows/files/wxMSW/) | \
    $(SED) -n 's,.*wxMSW-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) 's,png_check_sig,png_sig_cmp,g'                       -i '$(1)/configure'
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
        --with-regex=yes \
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
        --without-odbc
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= __install_wxrc___depname=
    $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/bin/wx-config' '$(PREFIX)/bin/$(TARGET)-wx-config'

    # build the wxWidgets variant without unicode support
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,wxwidgets)
    $(SED) 's,png_check_sig,png_sig_cmp,g'                       -i '$(1)/$(wxwidgets_SUBDIR)/configure'
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
        --with-regex=yes \
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
        --without-odbc
    $(MAKE) -C '$(1)/$(wxwidgets_SUBDIR)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    # backup of the unicode wx-config script
    # such that "make install" won't overwrite it
    mv '$(PREFIX)/$(TARGET)/bin/wx-config' '$(PREFIX)/$(TARGET)/bin/wx-config-backup'

    $(MAKE) -C '$(1)/$(wxwidgets_SUBDIR)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= __install_wxrc___depname=
    mv '$(PREFIX)/$(TARGET)/bin/wx-config' '$(PREFIX)/$(TARGET)/bin/wx-config-nounicode'
    $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/bin/wx-config-nounicode' '$(PREFIX)/bin/$(TARGET)-wx-config-nounicode'

    # restore the unicode wx-config script
    mv '$(PREFIX)/$(TARGET)/bin/wx-config-backup' '$(PREFIX)/$(TARGET)/bin/wx-config'
endef
