# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := atkmm
$(PKG)_WEBSITE  := https://www.gtkmm.org/
$(PKG)_DESCR    := ATKmm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.22.7
$(PKG)_CHECKSUM := bfbf846b409b4c5eb3a52fa32a13d86936021969406b3dcafd4dd05abd70f91b
$(PKG)_SUBDIR   := atkmm-$($(PKG)_VERSION)
$(PKG)_FILE     := atkmm-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/atkmm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc atk glibmm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.gnome.org/browse/atkmm/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
