# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gstreamer
$(PKG)_WEBSITE  := https://gstreamer.freedesktop.org/modules/gstreamer.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.20.3
$(PKG)_CHECKSUM := 607daf64bbbd5fb18af9d17e21c0d22c4d702fffe83b23cb22d1b1af2ca23a2a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://gstreamer.freedesktop.org/src/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc dlfcn-win32 glib pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://cgit.freedesktop.org/gstreamer/gstreamer/refs/tags' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?h=[^0-9]*\\([0-9]\..[02468]\.[0-9][^']*\\)'.*,\\1,p" | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dtests=disabled \
        -Dexamples=disabled \
        -Dintrospection=disabled \
        -Ddoc=disabled \
        $(PKG_MESON_OPTS) \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install

    # some .dlls are installed to lib - no obvious way to change
    $(if $(BUILD_SHARED),
        $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0'
        mv -vf '$(PREFIX)/$(TARGET)/lib/gstreamer-1.0/'*.dll '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/'
    )
endef
