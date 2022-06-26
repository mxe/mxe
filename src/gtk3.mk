# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gtk3
$(PKG)_WEBSITE  := https://gtk.org/
$(PKG)_DESCR    := GTK+
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.24.32
$(PKG)_CHECKSUM := a667e13f8f86ea44455b0443f4870bf23f53f6707c1df436eb2b516c62496bff
$(PKG)_SUBDIR   := gtk+-$($(PKG)_VERSION)
$(PKG)_FILE     := gtk+-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/gtk+/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper atk cairo gdk-pixbuf gettext glib jasper jpeg libepoxy libpng pango tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/gtk+/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    grep '^3\.' | \
    grep -v '^3\.9[0-9]' | \
    head -1
endef

define $(PKG)_BUILD
    # workaround for gcc12 snapshot
    $(if $(call gte, $(word 1,$(subst ., ,$(subst -, ,$(gcc_VERSION)))), 12), \
    	$(SED) -i '/-Werror=array-bounds/d' '$(SOURCE_DIR)/meson.build')
    # Meson configure, with additional options for GTK
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dtests=false \
        -Dexamples=false \
        -Ddemos=false \
        -Dinstalled_tests=false \
        -Dbuiltin_immodules=yes \
        -Dintrospection=false \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    DESTDIR="/" \
        '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install

    # Just compile our MXE testfile
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-gtk3.exe' \
        `'$(TARGET)-pkg-config' gtk+-3.0 --cflags --libs`
endef
