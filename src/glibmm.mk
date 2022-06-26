# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := glibmm
$(PKG)_WEBSITE  := https://www.gtkmm.org/
$(PKG)_DESCR    := GLibmm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.66.2
$(PKG)_CHECKSUM := b2a4cd7b9ae987794cbb5a1becc10cecb65182b9bb841868625d6bbb123edb1d
$(PKG)_SUBDIR   := glibmm-$($(PKG)_VERSION)
$(PKG)_FILE     := glibmm-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/glibmm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper glib libsigc++

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/glibmm/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dbuild-examples=false \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
