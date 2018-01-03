# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gst-plugins-good
$(PKG)_WEBSITE  := https://gstreamer.freedesktop.org/modules/gst-plugins-good.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.12.3
$(PKG)_CHECKSUM := 13e7f479296891fef5a686438f20ba7d534680becf2269ecc5ee24aa83b45f03
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://gstreamer.freedesktop.org/src/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc cairo flac gdk-pixbuf glib gst-plugins-base gstreamer jpeg libcaca \
                   liboil libpng libshout libsoup libvpx libxml2 speex taglib wavpack

$(PKG)_UPDATE = $(subst gstreamer/refs,gst-plugins-good/refs,$(gstreamer_UPDATE))

define $(PKG)_BUILD
    # The value for WAVE_FORMAT_DOLBY_AC3_SPDIF comes from vlc and mplayer:
    #   https://www.videolan.org/developers/vlc/doc/doxygen/html/vlc__codecs_8h-source.html
    #   https://lists.mplayerhq.hu/pipermail/mplayer-cvslog/2004-August/019283.html
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-debug \
        --disable-examples \
        --disable-aalib \
        $(if $(BUILD_SHARED), --disable-shout2) \
        --disable-x
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS) CFLAGS='-DWAVE_FORMAT_DOLBY_AC3_SPDIF=0x0092'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install CFLAGS='-DWAVE_FORMAT_DOLBY_AC3_SPDIF=0x0092'

    # some .dlls are installed to lib - no obvious way to change
    $(if $(BUILD_SHARED),
        $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0'
        mv -vf '$(PREFIX)/$(TARGET)/lib/gstreamer-1.0/'*.dll '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/'
    )
endef
