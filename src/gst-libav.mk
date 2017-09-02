# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gst-libav
$(PKG)_WEBSITE  := https://gstreamer.freedesktop.org/modules/gst-libav.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.12.2
$(PKG)_CHECKSUM := 5bb735b9bb218b652ae4071ea6f6be8eaae55e9d3233aec2f36b882a27542db3
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://gstreamer.freedesktop.org/src/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gst-plugins-base

$(PKG)_UPDATE = $(subst gstreamer/refs,gst-libav/refs,$(gstreamer_UPDATE))

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # some .dlls are installed to lib - no obvious way to change
    $(if $(BUILD_SHARED),
        $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0'
        mv -vf '$(PREFIX)/$(TARGET)/lib/gstreamer-1.0/'*.dll '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/'
    )
endef
