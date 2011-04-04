# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# librsvg
PKG             := librsvg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.34.0
$(PKG)_CHECKSUM := 59e01568a6b201fc45828a76b942f790859cddeb
$(PKG)_SUBDIR   := librsvg-$($(PKG)_VERSION)
$(PKG)_FILE     := librsvg-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://librsvg.sourceforge.net/
$(PKG)_URL      := http://ftp.gnome.org/pub/GNOME/sources/librsvg/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib libgsf cairo pango gtk2 libcroco

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/librsvg/refs/tags' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9][^<]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-pixbuf-loader \
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
