# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := x264
$(PKG)_WEBSITE  := https://www.videolan.org/developers/x264.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 20180806-2245
$(PKG)_CHECKSUM := 9f876c88aeb21fa9315e4a078931faf6fc0d3c3f47e05a306d2fdc62ea0afea2
$(PKG)_SUBDIR   := $(PKG)-snapshot-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-snapshot-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://download.videolan.org/pub/videolan/$(PKG)/snapshots/$($(PKG)_FILE)
$(PKG)_DEPS     := cc liblsmash $(BUILD)~nasm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.videolan.org/?p=x264.git;a=shortlog' | \
    $(SED) -n 's,.*\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\).*,\1\2\3-2245,p' | \
    $(SORT) | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && AS='$(PREFIX)/$(BUILD)/bin/nasm' '$(SOURCE_DIR)/configure'\
        $(MXE_CONFIGURE_OPTS) \
        --cross-prefix='$(TARGET)'- \
        --enable-win32thread \
        --disable-lavf \
        --disable-swscale   # Avoid circular dependency with ffmpeg. Remove if undesired.
    $(MAKE) -C '$(BUILD_DIR)' -j 1 uninstall
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
