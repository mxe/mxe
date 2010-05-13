# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GTK+
PKG             := gtk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.20.1
$(PKG)_CHECKSUM := a80953b4e81c6a5bc2a986852f7fe60c8704cc02
$(PKG)_SUBDIR   := gtk+-$($(PKG)_VERSION)
$(PKG)_FILE     := gtk+-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gtk.org/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gtk+/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gettext libpng jpeg tiff jasper glib atk pango cairo

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/gtk+/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9]*\.[0-9]*[02468]\.[^<]*\)<.*,\1,p' | \
    grep -v '^2\.9' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,DllMain,static _disabled_DllMain,' '$(1)/gdk/win32/gdkmain-win32.c'
    $(SED) -i 's,DllMain,static _disabled_DllMain,' '$(1)/gdk-pixbuf/gdk-pixbuf-io.c'
    $(SED) -i 's,DllMain,static _disabled_DllMain,' '$(1)/gtk/gtkmain.c'
    $(SED) -i 's,__declspec(dllimport),,' '$(1)/gdk/gdktypes.h'
    $(SED) -i 's,^\(Libs:.*\)@GTK_EXTRA_LIBS@,\1@GTK_DEP_LIBS@,' '$(1)/gtk+-2.0.pc.in'
    $(SED) -i 's,^\(gtkbuiltincache\.h:\),_disabled_\1,' '$(1)/gtk/Makefile.in'
    $(SED) -i 's,^\(install-data-local:.*\) install-libtool-import-lib,\1,' '$(1)/modules/other/gail/libgail-util/Makefile.in'
    $(SED) -i 's,\(BUILT_SOURCES.*=.*\)test-inline-pixbufs.h,\1,' '$(1)/demos/Makefile.in'
    $(SED) -i 's,"[^"]*must build as DLL[^"]*","(disabled warning)",' '$(1)/configure'
    $(SED) -i 's,enable_static=no,enable_static=yes,' '$(1)/configure'
    $(SED) -i 's,enable_shared=yes,enable_shared=no,' '$(1)/configure'
    $(SED) -i 's,\(STATIC_LIB_DEPS="[^"]*\) \$$LIBJASPER,\1 $$LIBJASPER $$LIBJPEG,' '$(1)/configure'
    $(SED) -i 's/-Wl,-luuid/-luuid/' '$(1)/configure'
    $(SED) -i 's/gio-unix/gio/' '$(1)/configure'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'
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

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-gtk.exe' \
        `'$(TARGET)-pkg-config' gtk+-2.0 --cflags --libs`
endef
