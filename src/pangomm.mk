# This file is part of MXE.
# See index.html for further information.

PKG             := pangomm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.34.0
$(PKG)_CHECKSUM := 15d89717a390a0c78c01871190c8febd29dad684
$(PKG)_SUBDIR   := pangomm-$($(PKG)_VERSION)
$(PKG)_FILE     := pangomm-$($(PKG)_VERSION).tar.xz
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

$(PKG)_BUILD_SHARED =
