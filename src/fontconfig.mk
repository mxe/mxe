# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := fontconfig
$(PKG)_WEBSITE  := https://fontconfig.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.18.4
$(PKG)_CHECKSUM := f10495c6d8cad87089b9bfa583491a7ef63180a7be19339e1f02c60c4f35a152
$(PKG)_SUBDIR   := fontconfig-$($(PKG)_VERSION)
$(PKG)_FILE     := fontconfig-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://gitlab.freedesktop.org/fontconfig/fontconfig/-/archive/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc expat freetype-bootstrap gettext libiconv meson-wrapper

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.freedesktop.org/fontconfig/fontconfig/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dtests=disabled \
        -Ddoc=disabled \
        -Diconv=enabled \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
