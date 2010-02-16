# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# librsvg
PKG             := librsvg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.26.0
$(PKG)_CHECKSUM := 61044be4bcd5945f5711f788e1aa303a80b69e32
$(PKG)_SUBDIR   := librsvg-$($(PKG)_VERSION)
$(PKG)_FILE     := librsvg-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://librsvg.sourceforge.net/
$(PKG)_URL      := http://ftp.gnome.org/pub/GNOME/sources/librsvg/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib libgsf cairo pango

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/librsvg/log' | \
    grep '<a href=' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9][0-9.]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,glib-mkenums,$(PREFIX)/$(TARGET)/bin/glib-mkenums,g' -i '$(1)'/Makefile.in
    $(SED) 's,^\(Requires:.*\),\1 libgsf-1 pangocairo,' -i '$(1)'/librsvg-2.0.pc.in
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-pixbuf-loader \
        --disable-gtk-theme \
        --disable-mozilla-plugin \
        --disable-gtk-doc \
        --with-svgz \
        --without-croco \
        --without-x
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-librsvg.exe' \
        `'$(TARGET)-pkg-config' librsvg-2.0 --cflags --libs`
endef
