# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gtk4
$(PKG)_WEBSITE  := https://gtk.org/
$(PKG)_DESCR    := GTK4
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.18.6
$(PKG)_CHECKSUM := e1817c650ddc3261f9a8345b3b22a26a5d80af154630dedc03cc7becefffd0fa
$(PKG)_SUBDIR   := gtk-$($(PKG)_VERSION)
$(PKG)_FILE     := gtk-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/gtk/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := meson-wrapper glib gdk-pixbuf pango libiconv gettext fontconfig cairo libepoxy gst-plugins-bad graphene lzo

define $(PKG)_BUILD
    # Meson configure, with additional options for GTK
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dbuild-testsuite=false \
        -Dbuild-examples=false \
        -Dbuild-tests=false \
        -Dbuild-demos=false \
        -Dintrospection=disabled \
        -Dvulkan=disabled \
        -Dc_args='-Wno-incompatible-pointer-types' \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    DESTDIR="/" \
        '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
