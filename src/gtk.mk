# GTK+

PKG            := gtk
$(PKG)_VERSION := 2.14.7
$(PKG)_SUBDIR  := gtk+-$($(PKG)_VERSION)
$(PKG)_FILE    := gtk+-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE := http://www.gtk.org/
$(PKG)_URL     := http://ftp.gnome.org/pub/gnome/sources/gtk+/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc gettext libpng jpeg tiff jasper glib atk pango cairo

define $(PKG)_UPDATE
    wget -q -O- 'http://www.gtk.org/download-windows.html' | \
    grep 'gtk+-' | \
    $(SED) -n 's,.*gtk+-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    sed 's,DllMain,static _disabled_DllMain,' -i '$(1)/gdk/win32/gdkmain-win32.c'
    sed 's,DllMain,static _disabled_DllMain,' -i '$(1)/gdk-pixbuf/gdk-pixbuf-io.c'
    sed 's,DllMain,static _disabled_DllMain,' -i '$(1)/gtk/gtkmain.c'
    sed 's,__declspec(dllimport),,' -i '$(1)/gdk/gdktypes.h'
    sed 's,^\(Libs:.*\)@GTK_EXTRA_LIBS@,\1@GTK_DEP_LIBS@,' -i '$(1)/gtk+-2.0.pc.in'
    sed 's,^\(gtkbuiltincache\.h:\),_disabled_\1,' -i '$(1)/gtk/Makefile.in'
    sed 's,^\(install-data-local:.*\) install-libtool-import-lib,\1,' -i '$(1)/modules/other/gail/libgail-util/Makefile.in'
    sed 's,\(BUILT_SOURCES.*=.*\)test-inline-pixbufs.h,\1,' -i '$(1)/demos/Makefile.in'
    sed 's,"[^"]*must build as DLL[^"]*","(disabled warning)",' -i '$(1)/configure'
    sed 's,enable_static=no,enable_static=yes,' -i '$(1)/configure'
    sed 's,enable_shared=yes,enable_shared=no,' -i '$(1)/configure'
    sed 's,\(STATIC_LIB_DEPS="[^"]*\) \$$LIBJPEG,\1 $$LIBJASPER $$LIBJPEG,' -i '$(1)/configure'
    sed 's/-Wl,-luuid/-luuid/' -i '$(1)/configure'
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
