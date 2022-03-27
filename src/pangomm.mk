# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pangomm
$(PKG)_WEBSITE  := https://www.pango.org/
$(PKG)_DESCR    := Pangomm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.46.2
$(PKG)_CHECKSUM := 57442ab4dc043877bfe3839915731ab2d693fc6634a71614422fb530c9eaa6f4
$(PKG)_SUBDIR   := pangomm-$($(PKG)_VERSION)
$(PKG)_FILE     := pangomm-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/pangomm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper cairomm glibmm pango

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/pangomm/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        '$(BUILD_DIR)' '$(SOURCE_DIR)' && \
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' && \
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
