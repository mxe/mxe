# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gst-plugins-good
$(PKG)_WEBSITE  := https://gstreamer.freedesktop.org/modules/gst-plugins-good.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.20.1
$(PKG)_CHECKSUM := 3c66876f821d507bcdbebffb08b4f31a322727d6753f65a0f02c905ecb7084aa
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
    CFLAGS='-DWAVE_FORMAT_DOLBY_AC3_SPDIF=0x0092' \
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dtests=disabled \
        -Dexamples=disabled \
        -Ddoc=disabled \
        -Daalib=disabled \
        $(if $(BUILD_SHARED), -Dshout2=disabled) \
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
