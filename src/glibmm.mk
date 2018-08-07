# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := glibmm
$(PKG)_WEBSITE  := https://www.gtkmm.org/
$(PKG)_DESCR    := GLibmm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.56.0
$(PKG)_CHECKSUM := 6e74fcba0d245451c58fc8a196e9d103789bc510e1eee1a9b1e816c5209e79a9
$(PKG)_SUBDIR   := glibmm-$($(PKG)_VERSION)
$(PKG)_FILE     := glibmm-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/glibmm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc glib libsigc++

define $(PKG)_UPDATE
    $(call MXE_GET_GH_TAGS,GNOME/glibmm) | \
    $(SED) -n 's,^\([0-9]*\.[0-9]*[02468].*\),\1,p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        CXX='$(TARGET)-g++' \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        GLIB_COMPILE_SCHEMAS='$(PREFIX)/$(TARGET)/bin/glib-compile-schemas' \
        $(shell [ `uname -s` == Darwin ] && echo "PERL=/usr/bin/perl") \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)/gio/src' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= MISC_STUFF=
    $(MAKE) -C '$(1)'         -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
