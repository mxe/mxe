# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsoup
$(PKG)_WEBSITE  := https://wiki.gnome.org/Projects/libsoup
$(PKG)_DESCR    := HTTP client/server library for GNOME
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.74.2
$(PKG)_APIVER   := 2.4
$(PKG)_CHECKSUM := c9dc5d6499377598b5189acb787dd37c14484f8a50e399d94451c13b4af88b0f
$(PKG)_GH_CONF  := GNOME/libsoup/tags,,,pre\|SOUP\|base
$(PKG)_DEPS     := cc meson-wrapper glib libpsl libxml2 sqlite

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dintrospection=disabled \
        -Dtests=false \
        -Dinstalled_tests=false \
        -Dvapi=disabled \
        -Dgssapi=disabled \
        -Dsysprof=disabled \
        -Dtls_check=false \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install

    $(TARGET)-gcc \
        -W -Wall -Werror -ansi \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config $(PKG)-$($(PKG)_APIVER) --cflags --libs`
endef
