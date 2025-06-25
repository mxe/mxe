# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libxml2
$(PKG)_WEBSITE  := http://xmlsoft.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.14.4
$(PKG)_CHECKSUM := 24175ec30a97cfa86bdf9befb7ccf4613f8f4b2713c5103e0dd0bc9c711a2773
$(PKG)_SUBDIR   := libxml2-$($(PKG)_VERSION)
$(PKG)_FILE     := libxml2-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/libxml2/2.14/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftp.osuosl.org/pub/blfs/conglomeration/libxml2/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libiconv xz zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/libxml2/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\([0-9,\.]\+\)<.*,\\1,p" | \
    $(SORT) -Vr | head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,`uname`,MinGW,g' '$(1)/xml2-config.in'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-zlib='$(PREFIX)/$(TARGET)' \
        --without-debug \
        --without-python \
        --without-threads
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    ln -sf '$(PREFIX)/$(TARGET)/bin/xml2-config' '$(PREFIX)/bin/$(TARGET)-xml2-config'
endef
