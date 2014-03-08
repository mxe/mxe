# This file is part of MXE.
# See index.html for further information.

PKG             := gdk-pixbuf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.30.3
$(PKG)_CHECKSUM := 22d1e53be4ccecd49290d8f1ba188cc51dc4fe88
$(PKG)_SUBDIR   := gdk-pixbuf-$($(PKG)_VERSION)
$(PKG)_FILE     := gdk-pixbuf-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib libpng jpeg tiff jasper libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/gdk-pixbuf/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9]*\.[0-9]*[02468]\.[^<]*\)<.*,\1,p' | \
    grep -v '^2\.9' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi -I'$(PREFIX)/$(TARGET)/share/aclocal'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-modules \
        --with-included-loaders \
        --without-gdiplus \
        LIBS="`'$(TARGET)-pkg-config' --libs libtiff-4`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
