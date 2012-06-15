# This file is part of MXE.
# See index.html for further information.

PKG             := pangomm
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := ee83497485e180708dffbf2e68d633ae8d5a36b4
$(PKG)_SUBDIR   := pangomm-$($(PKG)_VERSION)
$(PKG)_FILE     := pangomm-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/pangomm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc cairomm glibmm pango

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/pangomm/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=\\([0-9][^']*\\)'.*,\\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
