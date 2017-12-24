# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := glibmm
$(PKG)_WEBSITE  := https://www.gtkmm.org/
$(PKG)_DESCR    := GLibmm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.42.0
$(PKG)_CHECKSUM := 985083d97378d234da27a7243587cc0d186897a4b2d3c1286f794089be1a3397
$(PKG)_SUBDIR   := glibmm-$($(PKG)_VERSION)
$(PKG)_FILE     := glibmm-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/glibmm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc glib libsigc++

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.gnome.org/browse/glibmm/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9]*\.[0-9]*[02468]\.[^<]*\)<.*,\1,p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        CXX='$(TARGET)-g++' \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        GLIB_COMPILE_SCHEMAS='$(PREFIX)/$(TARGET)/bin/glib-compile-schemas' \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)/gio/src' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= MISC_STUFF=
    $(MAKE) -C '$(1)'         -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
