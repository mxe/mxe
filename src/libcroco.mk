# This file is part of MXE.
# See index.html for further information.

PKG             := libcroco
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 4b0dd540a47f2492b1ac7cd7e3ec63c2ef4c9c2a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://ftp.gnome.org/pub/GNOME/sources/libcroco/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/libcroco/refs/tags' | \
    $(SED) -n 's,.*<a[^>]*>LIBCROCO_\([0-9][0-9_]*\)<.*,\1,p' | \
    $(SED) 's,_,.,g' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-gtk-doc
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
