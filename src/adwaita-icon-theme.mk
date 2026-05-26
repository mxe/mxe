# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := adwaita-icon-theme
$(PKG)_WEBSITE  := https://gtk.org/
$(PKG)_DESCR    := GTK+
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.38.0
$(PKG)_CHECKSUM := 6683a1aaf2430ccd9ea638dd4bfe1002bc92b412050c3dba20e480f979faaf97
$(PKG)_SUBDIR   := adwaita-icon-theme-$($(PKG)_VERSION)
$(PKG)_FILE     := adwaita-icon-theme-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/adwaita-icon-theme/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gettext librsvg gtk3

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/adwaita-icon-theme/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    grep '^3\.' | \
    grep -v '^3\.9[0-9]' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT) EXTRA_DIST=
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT) EXTRA_DIST=
endef
