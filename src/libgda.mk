# This file is part of MXE.
# See index.html for further information.

# LibGDA
PKG             := libgda
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 61d0b498202b780750633cc2e957c40325d6c705
$(PKG)_SUBDIR   := libgda-$($(PKG)_VERSION)
$(PKG)_FILE     := libgda-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/libgda/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib libxml2 mdbtools postgresql

define $(PKG)_UPDATE
    echo 'TODO: Updates for package libgda need to be fixed.' >&2;
    echo $(libgda_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-gtk-doc \
        --without-bdb \
        --with-mdb \
        --without-oracle \
        --without-mysql \
        --without-firebird \
        --without-java \
        --enable-binreloc \
        --disable-crypto
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
