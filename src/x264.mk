# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := x264
$(PKG)_WEBSITE  := https://www.videolan.org/developers/x264.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := b35605ace3ddf7c1a5d67a2eb553f034aef41d55
$(PKG)_CHECKSUM := 6eeb82934e69fd51e043bd8c5b0d152839638d1ce7aa4eea65a3fedcf83ff224
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://code.videolan.org/videolan/x264/-/archive/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc liblsmash $(BUILD)~nasm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://code.videolan.org/videolan/x264/-/commits/master.atom' | \
    $(SED) -n 's,.*<id>.*commit/\([^<]*\)</id>.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # --disable-swscale avoids circular dependency with ffmpeg. Remove if undesired.
    cd '$(BUILD_DIR)' && AS='$(PREFIX)/$(BUILD)/bin/nasm' '$(SOURCE_DIR)/configure'\
        $(MXE_CONFIGURE_OPTS) \
        --cross-prefix='$(TARGET)'- \
        --disable-lavf \
        --disable-swscale \
        --enable-win32thread
    $(MAKE) -C '$(BUILD_DIR)' -j 1 uninstall
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
