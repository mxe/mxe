# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := atkmm
$(PKG)_WEBSITE  := https://www.gtkmm.org/
$(PKG)_DESCR    := ATKmm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.24.2
$(PKG)_CHECKSUM := ff95385759e2af23828d4056356f25376cfabc41e690ac1df055371537e458bd
$(PKG)_SUBDIR   := atkmm-$($(PKG)_VERSION)
$(PKG)_FILE     := atkmm-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/atkmm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc atk glibmm

define $(PKG)_UPDATE
    $(call MXE_GET_GH_TAGS,GNOME/atkmm) | \
    $(SED) -n 's,^\([0-9]*\.[0-9]*[02468]\..*\),\1,p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD_POSIX
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(call MXE_REQUIRE_POSIX,$(PKG))
