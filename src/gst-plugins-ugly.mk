#This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gst-plugins-ugly
$(PKG)_WEBSITE  := https://gstreamer.freedesktop.org/modules/gst-plugins-ugly.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.16.1
$(PKG)_CHECKSUM := 4bf913b2ca5195ac3b53b5e3ade2dc7c45d2258507552ddc850c5fa425968a1d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://gstreamer.freedesktop.org/src/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc a52dec gst-plugins-base gstreamer lame libcdio libdvdread \
                   opencore-amr twolame x264

$(PKG)_UPDATE = $(subst gstreamer/refs,gst-plugins-ugly/refs,$(gstreamer_UPDATE))

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-debug \
        --disable-examples \
        --disable-opengl
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # some .dlls are installed to lib - no obvious way to change
    $(if $(BUILD_SHARED),
        $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0'
        mv -vf '$(PREFIX)/$(TARGET)/lib/gstreamer-1.0/'*.dll '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/'
    )
endef
