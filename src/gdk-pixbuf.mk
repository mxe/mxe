# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gdk-pixbuf
$(PKG)_WEBSITE  := https://gtk.org/
$(PKG)_DESCR    := GDK-pixbuf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.32.3
$(PKG)_CHECKSUM := 2b6771f1ac72f687a8971e59810b8dc658e65e7d3086bd2e676e618fd541d031
$(PKG)_SUBDIR   := gdk-pixbuf-$($(PKG)_VERSION)
$(PKG)_FILE     := gdk-pixbuf-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/gdk-pixbuf/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc glib jasper jpeg libiconv libpng tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/gdk-pixbuf/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    grep -v '^2\.9' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi -I'$(PREFIX)/$(TARGET)/share/aclocal'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        $(if $(BUILD_STATIC), \
           --disable-modules,) \
        --with-included-loaders \
        --without-gdiplus \
        LIBS="`'$(TARGET)-pkg-config' --libs libtiff-4`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
