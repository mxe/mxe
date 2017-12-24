# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libgda
$(PKG)_WEBSITE  := http://www.gnome-db.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2.13
$(PKG)_CHECKSUM := 25b75951f8f38fd58a403389566a0aae2f83b39d4225bc3acf5f2d68895ab4c3
$(PKG)_SUBDIR   := libgda-$($(PKG)_VERSION)
$(PKG)_FILE     := libgda-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/libgda/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc glib libxml2 mdbtools

define $(PKG)_UPDATE
    echo 'TODO: Updates for package libgda need to be fixed.' >&2;
    echo $(libgda_VERSION)
endef

define $(PKG)_BUILD
    $(SED) -i 's,glib-mkenums,'$(PREFIX)/$(TARGET)/bin/glib-mkenums',g' '$(1)/libgda/Makefile.in'
    $(SED) -i 's,glib-mkenums,'$(PREFIX)/$(TARGET)/bin/glib-mkenums',g' '$(1)/libgda/sql-parser/Makefile.in'
    $(SED) -i 's,glib-mkenums,'$(PREFIX)/$(TARGET)/bin/glib-mkenums',g' '$(1)/libgda-ui/Makefile.in'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-gtk-doc \
        --without-bdb \
        --with-mdb \
        --without-postgres \
        --without-oracle \
        --without-mysql \
        --without-firebird \
        --without-java \
        --enable-binreloc \
        --disable-crypto \
        GLIB_GENMARSHAL='$(PREFIX)/$(TARGET)/bin/glib-genmarshal'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_SHARED =
