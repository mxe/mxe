# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gssdp
$(PKG)_WEBSITE  := https://download.gnome.org/
$(PKG)_DESCR    := A GObject-based API for handling resource discovery and announcement over SSDP
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.3
$(PKG)_CHECKSUM := 211387a62bc1d99821dd0333d873a781320287f5436f91e58b2ca145b378be41
$(PKG)_SUBDIR   := gssdp-$($(PKG)_VERSION)
$(PKG)_FILE     := gssdp-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/gssdp/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc glib libsoup

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/gssdp/-/tags' | \
    $(SED) -n "s,.*gssdp-\([0-9]\+\.[0-9]*[0-9]*\.[^']*\)\.tar.*,\1,p" | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
         $(MXE_CONFIGURE_OPTS) \
         CFLAGS='-D_WIN32_WINNT=0x0600 -DWINVER=0x0600'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' install
endef
