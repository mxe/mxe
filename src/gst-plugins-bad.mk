# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gst-plugins-bad
$(PKG)_WEBSITE  := https://gstreamer.freedesktop.org/modules/gst-plugins-bad.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.28.4
$(PKG)_CHECKSUM := 332b7320f30c60f2d5941446d03b9d05e3781f2c2561befbe88718bd777f0e47
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://gstreamer.freedesktop.org/src/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc chromaprint faad2 fdk-aac gst-plugins-base gstreamer gtk3 \
                   libass libbs2b libdvdnav libdvdread libgcrypt libmms libmodplug librsvg \
                   librtmp libsndfile libxml2 libwebp neon openal opencv openexr \
                   openjpeg openssl vo-aacenc vo-amrwbenc

$(PKG)_UPDATE = $(gstreamer_UPDATE)

define $(PKG)_BUILD
    # review meson_options.txt
    CFLAGS='-DHAVE_AUDCLNT_STREAMOPTIONS' \
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dtests=disabled \
        -Dexamples=disabled \
        -Dintrospection=disabled \
        -Ddoc=disabled \
        -Dd3d11=disabled \
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
