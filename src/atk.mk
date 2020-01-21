# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := atk
$(PKG)_WEBSITE  := https://gtk.org/
$(PKG)_DESCR    := ATK
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.16.0
$(PKG)_CHECKSUM := 095f986060a6a0b22eb15eef84ae9f14a1cf8082488faa6886d94c37438ae562
$(PKG)_SUBDIR   := atk-$($(PKG)_VERSION)
$(PKG)_FILE     := atk-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/atk/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gettext glib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/atk/tags' | \
    $(SED) -n "s,.*<a [^>]\+>ATK_\([0-9]\+_[0-9_]\+\)<.*,\1,p" | \
    $(SED) "s,_,.,g;" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT) SUBDIRS='atk po' SHELL=bash
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_CRUFT) SUBDIRS='atk po'
endef
