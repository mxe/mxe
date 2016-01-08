# This file is part of MXE.
# See index.html for further information.

PKG             := json-glib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.4
$(PKG)_CHECKSUM := 80f3593cb6bd13f1465828e46a9f740e2e9bd3cd2257889442b3e62bd6de05cd
$(PKG)_SUBDIR   := json-glib-$($(PKG)_VERSION)
$(PKG)_FILE     := json-glib-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/json-glib/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/json-glib/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9]*\.[0-9]*[02468]\.[^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)/json-glib' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
