# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := webrtc-audio-processing
$(PKG)_WEBSITE  := https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing
$(PKG)_DESCR    := WebRTC audio processing module - AEC3, noise suppression, AGC
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3
$(PKG)_CHECKSUM := 95552fc17faa0202133707bbb3727e8c2cf64d4266fe31bfdb2298d769c1db75
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://freedesktop.org/software/pulseaudio/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper abseil-cpp

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://freedesktop.org/software/pulseaudio/$(PKG)/' | \
    $(SED) -n 's,.*$(PKG)-\(1\.[0-9][^"]*\)\.tar\.gz".*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

$(PKG)_MESON_OPTS = $(if $(findstring i686,$(TARGET)),-Dc_args=-msse2 -Dcpp_args=-msse2)

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        $(PKG_MESON_OPTS) \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install

    '$(TARGET)-g++' \
        -std=c++17 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG)-1 --cflags --libs`
endef
