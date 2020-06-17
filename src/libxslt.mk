# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libxslt
$(PKG)_WEBSITE  := http://xmlsoft.org/XSLT/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.34
$(PKG)_CHECKSUM := 98b1bd46d6792925ad2dfe9a87452ea2adebf69dcb9919ffd55bf926a7f93f7f
$(PKG)_SUBDIR   := libxslt-$($(PKG)_VERSION)
$(PKG)_FILE     := libxslt-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://xmlsoft.org/sources/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libgcrypt libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/libxslt/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\([0-9,\.]\+\)<.*,\\1,p" | \
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
