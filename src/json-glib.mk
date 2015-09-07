# This file is part of MXE.
# See index.html for further information.

PKG             := json-glib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.4
$(PKG)_CHECKSUM := efdf5a66d1d8fb504448a40ba2352bbfef301074
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
        $(MXE_CONFIGURE_OPTS) \
        --enable-static \
        --disable-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

define $(PKG)_BUILD_SHARED
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-static \
        --enable-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
