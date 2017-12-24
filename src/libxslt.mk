# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libxslt
$(PKG)_WEBSITE  := http://xmlsoft.org/XSLT/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.29
$(PKG)_CHECKSUM := b5976e3857837e7617b29f2249ebb5eeac34e249208d31f1fbf7a6ba7a4090ce
$(PKG)_SUBDIR   := libxslt-$($(PKG)_VERSION)
$(PKG)_FILE     := libxslt-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://xmlsoft.org/sources/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://xmlsoft.org/libxslt/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libgcrypt libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.gnome.org/browse/libxslt/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?h=v\\([0-9][^']*\\)'.*,\\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --without-debug \
        --with-libxml-prefix='$(PREFIX)/$(TARGET)' \
        --without-python \
        --without-plugins
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
