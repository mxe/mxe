# This file is part of MXE.
# See index.html for further information.

PKG             := gtk3
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.14.4
$(PKG)_CHECKSUM := a006c716d723dab0c623491566e3292af84c87d9198a30199051d23cfc7bef2f
$(PKG)_SUBDIR   := gtk+-$($(PKG)_VERSION)
$(PKG)_FILE     := gtk+-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gtk+/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc atk cairo gdk-pixbuf gettext glib jasper jpeg libpng pango tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/gtk+/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9]*\.[0-9]*[02468]\.[^<]*\)<.*,\1,p' | \
    grep '^3\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
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

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-gtk3.exe' \
        `'$(TARGET)-pkg-config' gtk+-3.0 --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
