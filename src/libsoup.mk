# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsoup
$(PKG)_WEBSITE  := https://wiki.gnome.org/Projects/libsoup
$(PKG)_DESCR    := HTTP client/server library for GNOME
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.7.2
$(PKG)_APIVER   := 3.0
$(PKG)_CHECKSUM := 4f2c55aa4608fbca8bd979f3f7bd0add08ef999f16655c139e0839600c7768a3
$(PKG)_GH_CONF  := GNOME/libsoup/tags,,,pre\|SOUP\|base
$(PKG)_DEPS     := cc meson-wrapper glib libpsl libxml2 nghttp2 sqlite

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
