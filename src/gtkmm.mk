# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GTKMM
PKG             := gtkmm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.20.3
$(PKG)_CHECKSUM := ad53f52f18cc3021b7fd6cd06f965471039d5333
$(PKG)_SUBDIR   := gtkmm-$($(PKG)_VERSION)
$(PKG)_FILE     := gtkmm-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gtkmm.org/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gtkmm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gtk libsigc++ pangomm cairomm atkmm

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/gtkmm/refs/tags' | \
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
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
