# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := atk
$(PKG)_WEBSITE  := https://gtk.org/
$(PKG)_DESCR    := ATK
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.36.0
$(PKG)_CHECKSUM := fb76247e369402be23f1f5c65d38a9639c1164d934e40f6a9cf3c9e96b652788
$(PKG)_SUBDIR   := atk-$($(PKG)_VERSION)
$(PKG)_FILE     := atk-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/atk/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper glib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/atk/tags' | \
    $(SED) -n "s,.*<a [^>]\+>ATK_\([0-9]\+_[0-9_]\+\)<.*,\1,p" | \
    $(SED) "s,_,.,g;" | \
    head -1
endef

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) -Dintrospection=false '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
