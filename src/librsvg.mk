# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# librsvg
PKG             := librsvg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.26.2
$(PKG)_CHECKSUM := 3c529b5e28a8924fa95d74814dd63b53182c903c
$(PKG)_SUBDIR   := librsvg-$($(PKG)_VERSION)
$(PKG)_FILE     := librsvg-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://librsvg.sourceforge.net/
$(PKG)_URL      := http://ftp.gnome.org/pub/GNOME/sources/librsvg/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib libgsf cairo pango gtk libcroco

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/librsvg/refs/tags' | \
    $(SED) -n 's,.*<a[^>]*>LIBRSVG_\([0-9][0-9_]*\)<.*,\1,p' | \
    $(SED) 's,_,.,g' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,glib-mkenums,$(PREFIX)/$(TARGET)/bin/glib-mkenums,g'   '$(1)'/Makefile.in
    $(SED) -i 's,^\(Requires:.*\),\1 libgsf-1 pangocairo libcroco-0.6,' '$(1)'/librsvg-2.0.pc.in
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-pixbuf-loader \
        --disable-gtk-theme \
        --disable-mozilla-plugin \
        --disable-gtk-doc \
        --with-svgz \
        --with-croco \
        --without-x
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-librsvg.exe' \
        `'$(TARGET)-pkg-config' librsvg-2.0 --cflags --libs`
endef
