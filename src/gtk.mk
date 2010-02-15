# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GTK+
PKG             := gtk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.19.5
$(PKG)_CHECKSUM := 678f27ceef72853a650d045506f06a32905102fe
$(PKG)_SUBDIR   := gtk+-$($(PKG)_VERSION)
$(PKG)_FILE     := gtk+-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gtk.org/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gtk+/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gettext libpng jpeg tiff jasper glib atk pango cairo

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/cgit/gtk+/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=\\([0-9][^']*\\)'.*,\\1,p" | \
    grep -v '2\.18\.' | \
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
    $(SED) 's,\(STATIC_LIB_DEPS="[^"]*\) \$$LIBJASPER,\1 $$LIBJASPER $$LIBJPEG,' -i '$(1)/configure'
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

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        `'$(TARGET)-pkg-config' gtk+-2.0 --cflags` \
        '$(2).c' \
        `'$(TARGET)-pkg-config' gtk+-2.0 --libs` \
        -o '$(PREFIX)/$(TARGET)/bin/test-gtk.exe'
endef
