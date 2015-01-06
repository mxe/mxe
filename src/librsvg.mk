# This file is part of MXE.
# See index.html for further information.

PKG             := librsvg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.40.1
$(PKG)_CHECKSUM := abbfed10433b26e88f18fe62a9b84d48fc00b9e1
$(PKG)_SUBDIR   := librsvg-$($(PKG)_VERSION)
$(PKG)_FILE     := librsvg-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/GNOME/sources/librsvg/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib libgsf cairo pango gdk-pixbuf libcroco

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/librsvg/refs/tags' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9][^<]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-pixbuf-loader \
        --disable-gtk-doc \
        --enable-introspection=no
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -mwindows -W -Wall -Werror -Wno-error=deprecated-declarations \
        -std=c99 -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-librsvg.exe' \
        `'$(TARGET)-pkg-config' librsvg-2.0 --cflags --libs`
endef
