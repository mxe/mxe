# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GDK-pixbuf
PKG             := gdk-pixbuf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.22.1
$(PKG)_CHECKSUM := b452208963ddd84f7280865695b50255fcafaa2e
$(PKG)_SUBDIR   := gdk-pixbuf-$($(PKG)_VERSION)
$(PKG)_FILE     := gdk-pixbuf-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gdk-pixbuf.org/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib libpng jpeg tiff jasper libiconv

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/gdk-pixbuf/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9]*\.[0-9]*[02468]\.[^<]*\)<.*,\1,p' | \
    grep -v '^2\.9' | \
    head -1
endef

define $(PKG)_BUILD
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-modules \
        --with-included-loaders
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
