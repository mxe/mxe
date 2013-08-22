# This file is part of MXE.
# See index.html for further information.

PKG             := gtk3
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.9.12
$(PKG)_CHECKSUM := 1b4677b53892eb12637a227d5f6a427c8c4de2ba
$(PKG)_SUBDIR   := gtk+-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gtk+/3.9/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib atk pango cairo gdk-pixbuf


define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnome.org/pub/gnome/sources/gtk+/' | \
    $(SED) -n 's,.*<a href=\"\([0-9\.]{2-5}\)/\"\([0-9\.]{2-5}\)/</a>[ \t]*\([0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}\).*,\3,p' | \
    tail -1 
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-explicit-deps \
        --disable-glibtest \
        --disable-modules \
        --disable-cups \
        --disable-test-print-backend \
        --disable-gtk-doc \
        --disable-man \
        --with-included-immodules \
        --without-x
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

#    '$(TARGET)-gcc' \
#        -W -Wall -Werror -ansi \
#        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-gtk2.exe' \
#        `'$(TARGET)-pkg-config' gtk+-2.0 --cflags --libs`
endef

$(PKG)_BUILD_i686-pc-mingw32 =
$(PKG)_BUILD_i686-w64-mingw32 =
$(PKG)_BUILD_x86_64-w64-mingw32 =
