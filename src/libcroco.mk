# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Libcroco
PKG             := libcroco
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.6.2
$(PKG)_CHECKSUM := 4b0dd540a47f2492b1ac7cd7e3ec63c2ef4c9c2a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.freespiders.org/projects/libcroco/
$(PKG)_URL      := http://ftp.gnome.org/pub/GNOME/sources/libcroco/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib libxml2

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/libcroco/refs/tags' | \
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
