# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gtk2
$(PKG)_WEBSITE  := https://gtk.org/
$(PKG)_DESCR    := GTK+
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.24.30
$(PKG)_CHECKSUM := 0d15cec3b6d55c60eac205b1f3ba81a1ed4eadd9d0f8e7c508bc7065d0c4ca50
$(PKG)_SUBDIR   := gtk+-$($(PKG)_VERSION)
$(PKG)_FILE     := gtk+-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/gtk+/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc atk cairo gdk-pixbuf gettext glib jasper jpeg libpng pango tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/gtk+/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    grep -v '^2\.9' | \
    grep '^2\.' | \
    head -1
endef

define $(PKG)_PATCH_STATIC
    (cd $(SOURCE_DIR) && $(PATCH) -p1 -u) < $(TOP_DIR)/src/gtk2-patch-static-dllmain.diff
endef

define $(PKG)_PATCH_X64
    (cd $(SOURCE_DIR) && $(PATCH) -p1 -u) < $(TOP_DIR)/src/gtk2-remove-abi-compatibility-workarounds-x64.diff
endef

define $(PKG)_BUILD
    $(if $(BUILD_STATIC), $(call $(PKG)_PATCH_STATIC))
    $(if $(findstring x86_64, $(TARGET)), $(call $(PKG)_PATCH_X64))
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --enable-explicit-deps \
        --disable-glibtest \
        --disable-modules \
        --disable-cups \
        --disable-test-print-backend \
        --disable-gtk-doc \
        --disable-man \
        --with-included-immodules \
        --without-x
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT) EXTRA_DIST= SHELL='$(SHELL)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT) EXTRA_DIST= SHELL='$(SHELL)'

    # cleanup to avoid gtk2/3 conflicts (EXTRA_DIST doesn't exclude it)
    # and *.def files aren't really relevant for MXE
    rm -f '$(PREFIX)/$(TARGET)/lib/gailutil.def'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-gtk2.exe' \
        `'$(TARGET)-pkg-config' gtk+-2.0 gmodule-2.0 --cflags --libs`
endef
