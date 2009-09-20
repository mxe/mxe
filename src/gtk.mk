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

# GTK+
PKG             := gtk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.16.6
$(PKG)_CHECKSUM := f69cb48311d60664bac7cf68351c175c7a214ae6
$(PKG)_SUBDIR   := gtk+-$($(PKG)_VERSION)
$(PKG)_FILE     := gtk+-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gtk.org/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gtk+/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gettext libpng jpeg tiff jasper glib atk pango cairo

define $(PKG)_UPDATE
    wget -q -O- 'http://www.gtk.org/download-windows.html' | \
    grep 'gtk+-' | \
    $(SED) -n 's,.*gtk+-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,DllMain,static _disabled_DllMain,' -i '$(1)/gdk/win32/gdkmain-win32.c'
    $(SED) 's,DllMain,static _disabled_DllMain,' -i '$(1)/gdk-pixbuf/gdk-pixbuf-io.c'
    $(SED) 's,DllMain,static _disabled_DllMain,' -i '$(1)/gtk/gtkmain.c'
    $(SED) 's,__declspec(dllimport),,' -i '$(1)/gdk/gdktypes.h'
    $(SED) 's,^\(Libs:.*\)@GTK_EXTRA_LIBS@,\1@GTK_DEP_LIBS@,' -i '$(1)/gtk+-2.0.pc.in'
    $(SED) 's,^\(gtkbuiltincache\.h:\),_disabled_\1,' -i '$(1)/gtk/Makefile.in'
    $(SED) 's,^\(install-data-local:.*\) install-libtool-import-lib,\1,' -i '$(1)/modules/other/gail/libgail-util/Makefile.in'
    $(SED) 's,\(BUILT_SOURCES.*=.*\)test-inline-pixbufs.h,\1,' -i '$(1)/demos/Makefile.in'
    $(SED) 's,"[^"]*must build as DLL[^"]*","(disabled warning)",' -i '$(1)/configure'
    $(SED) 's,enable_static=no,enable_static=yes,' -i '$(1)/configure'
    $(SED) 's,enable_shared=yes,enable_shared=no,' -i '$(1)/configure'
    $(SED) 's,\(STATIC_LIB_DEPS="[^"]*\) \$$LIBJPEG,\1 $$LIBJASPER $$LIBJPEG,' -i '$(1)/configure'
    $(SED) 's/-Wl,-luuid/-luuid/' -i '$(1)/configure'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) 's,cross_compiling=no,cross_compiling=yes,' -i '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-explicit-deps \
        --disable-gdiplus \
        --disable-glibtest \
        --disable-modules \
        --disable-cups \
        --disable-test-print-backend \
        --disable-gtk-doc \
        --disable-man \
        --with-libpng \
        --with-libjpeg \
        --with-libtiff \
        --with-libjasper \
        --with-included-loaders \
        --with-included-immodules \
        --without-x
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
