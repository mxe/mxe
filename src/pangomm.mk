# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pangomm
$(PKG)_WEBSITE  := https://www.pango.org/
$(PKG)_DESCR    := Pangomm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.46.5
$(PKG)_CHECKSUM := 38ca0b050b065de4e3da0c182df657437757063bbf0c4b6c9567ddba019b1d68
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
