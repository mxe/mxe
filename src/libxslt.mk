# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libxslt
$(PKG)_WEBSITE  := http://xmlsoft.org/XSLT/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.33
$(PKG)_CHECKSUM := 8e36605144409df979cab43d835002f63988f3dc94d5d3537c12796db90e38c8
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
