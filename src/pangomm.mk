# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Pangomm
PKG             := pangomm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.28.2
$(PKG)_CHECKSUM := 31bcbb0c8773fdde6f4ea9b4a79fdf7159f94520
$(PKG)_SUBDIR   := pangomm-$($(PKG)_VERSION)
$(PKG)_FILE     := pangomm-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.pango.org/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/pangomm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc cairomm glibmm pango

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/pangomm/refs/tags' | \
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
