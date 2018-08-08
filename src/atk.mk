# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := atk
$(PKG)_WEBSITE  := https://gtk.org/
$(PKG)_DESCR    := ATK
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.28.1
$(PKG)_CHECKSUM := cd3a1ea6ecc268a2497f0cd018e970860de24a6d42086919d6bf6c8e8d53f4fc
$(PKG)_SUBDIR   := atk-$($(PKG)_VERSION)
$(PKG)_FILE     := atk-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/atk/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gettext glib

define $(PKG)_UPDATE
    $(call MXE_GET_GH_TAGS,GNOME/atk) | \
    $(SED) -n 's,ATK_\([0-9]*_[0-9]*[02468]_.*\),\1,p' | \
    $(SED) 's,_,.,g' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT) SUBDIRS='atk po' SHELL=bash
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_CRUFT) SUBDIRS='atk po'
endef
