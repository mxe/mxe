# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GTK+
PKG             := gtk2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.24.4
$(PKG)_CHECKSUM := c15a25ba49eb459b2c4cdc46baedf6cecf08cbcf
$(PKG)_SUBDIR   := gtk+-$($(PKG)_VERSION)
$(PKG)_FILE     := gtk+-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gtk.org/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gtk+/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gettext libpng jpeg tiff jasper glib atk pango cairo gdk-pixbuf

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/gtk+/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9]*\.[0-9]*[02468]\.[^<]*\)<.*,\1,p' | \
    grep -v '^2\.9' | \
    grep '^2\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
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
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-gtk2.exe' \
        `'$(TARGET)-pkg-config' gtk+-2.0 --cflags --libs`
endef
