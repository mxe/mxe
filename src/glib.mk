# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := glib
$(PKG)_WEBSITE  := https://gtk.org/
$(PKG)_DESCR    := GLib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.84.1
$(PKG)_CHECKSUM := 2b4bc2ec49611a5fc35f86aca855f2ed0196e69e53092bab6bb73396bf30789a
$(PKG)_SUBDIR   := glib-$($(PKG)_VERSION)
$(PKG)_FILE     := glib-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/glib/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper dbus gettext libffi libiconv pcre2 zlib $(BUILD)~$(PKG)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) := cc meson-wrapper gettext libffi libiconv zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/glib/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD_$(BUILD)
    # native build
    $(if $(findstring darwin, $(BUILD)), \
        CPPFLAGS='-I$(PREFIX)/$(TARGET).gnu/include' \
        LDFLAGS='-L$(PREFIX)/$(TARGET).gnu/lib' \,
        CPPFLAGS='-I$(PREFIX)/$(TARGET)/include' \
        LDFLAGS='-L$(PREFIX)/$(TARGET)/lib' \)
    '$(MXE_MESON_NATIVE_WRAPPER)' \
        --buildtype=release \
        -Dtests=false \
        $(if $(BUILD_STATIC),-Dintrospection=disabled) \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef

define $(PKG)_BUILD
    # other packages expect glib-tools in $(TARGET)/bin
    rm -f  '$(PREFIX)/$(TARGET)/bin/glib-*'
    ln -sf '$(PREFIX)/$(BUILD)/bin/glib-genmarshal'        '$(PREFIX)/$(TARGET)/bin/'
    ln -sf '$(PREFIX)/$(BUILD)/bin/glib-compile-schemas'   '$(PREFIX)/$(TARGET)/bin/'
    ln -sf '$(PREFIX)/$(BUILD)/bin/glib-compile-resources' '$(PREFIX)/$(TARGET)/bin/'

    # cross build with posix threads
    '$(MXE_MESON_WRAPPER)' \
        $(MXE_MESON_OPTS) \
        -Dtests=false \
        -Dforce_posix_threads=true \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
