# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gdk-pixbuf
$(PKG)_WEBSITE  := https://gtk.org/
$(PKG)_DESCR    := GDK-pixbuf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.42.10
$(PKG)_CHECKSUM := ee9b6c75d13ba096907a2e3c6b27b61bcd17f5c7ebeab5a5b439d2f2e39fe44b
$(PKG)_SUBDIR   := gdk-pixbuf-$($(PKG)_VERSION)
$(PKG)_FILE     := gdk-pixbuf-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/gdk-pixbuf/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper glib jasper jpeg libiconv libpng tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/gdk-pixbuf/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    grep -v '^2\.9' | \
    head -1
endef

define $(PKG)_BUILD
    LDFLAGS="`'$(TARGET)-pkg-config' --libs libjpeg libpng libtiff-4`" \
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
      -Dinstalled_tests=false \
      -Dintrospection=disabled \
      -Dman=false \
      $(if $(BUILD_STATIC),-Dbuiltin_loaders=all) \
    '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
