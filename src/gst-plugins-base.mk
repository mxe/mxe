# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gst-plugins-base
$(PKG)_WEBSITE  := https://gstreamer.freedesktop.org/modules/gst-plugins-base.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.16.1
$(PKG)_CHECKSUM := 5c3cc489933d0597087c9bc6ba251c93693d64554bcc563539a084fa2d5fcb2b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://gstreamer.freedesktop.org/src/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc glib gstreamer liboil libxml2 ogg pango theora vorbis

$(PKG)_UPDATE = $(subst gstreamer/refs,gst-plugins-base/refs,$(gstreamer_UPDATE))

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-debug \
        --disable-examples \
        --disable-x
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # some .dlls are installed to lib - no obvious way to change
    $(if $(BUILD_SHARED),
        $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0'
        mv -vf '$(PREFIX)/$(TARGET)/lib/gstreamer-1.0/'*.dll '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/'
    )
endef
