# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pangomm
$(PKG)_WEBSITE  := https://www.pango.org/
$(PKG)_DESCR    := Pangomm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.40.2
$(PKG)_CHECKSUM := 0a97aa72513db9088ca3034af923484108746dba146e98ed76842cf858322d05
$(PKG)_SUBDIR   := pangomm-$($(PKG)_VERSION)
$(PKG)_FILE     := pangomm-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/pangomm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc cairomm glibmm pango

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/pangomm/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
