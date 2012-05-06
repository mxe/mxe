# This file is part of MXE.
# See index.html for further information.

PKG             := librsvg
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 1084015373e90ff8fccbae4b27ee778bbdf14d40
$(PKG)_SUBDIR   := librsvg-$($(PKG)_VERSION)
$(PKG)_FILE     := librsvg-$($(PKG)_VERSION).tar.xz
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
        --build="`config.guess`" \
        $(LINK_STYLE) \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-pixbuf-loader \
        --disable-gtk-theme \
        --disable-gtk-doc \
        --enable-introspection=no
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-librsvg.exe' \
        `'$(TARGET)-pkg-config' librsvg-2.0 --cflags --libs`
endef

$(PKG)_BUILD_i686-static-mingw32   = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-static-mingw32 =
