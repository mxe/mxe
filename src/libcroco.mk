# This file is part of MXE.
# See index.html for further information.

PKG             := libcroco
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.6.2
$(PKG)_CHECKSUM := be24853f64c09b63d39e563fb0222e29bae1a33c3d9f6cbffc0bc27669371749
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
        $(MXE_CONFIGURE_OPTS) \
        --disable-gtk-doc
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
