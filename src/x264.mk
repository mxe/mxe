# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := x264
$(PKG)_WEBSITE  := https://www.videolan.org/developers/x264.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0480cb05fa188d37ae87e8f4fd8f1aea3711f7ee
$(PKG)_CHECKSUM := f05c59f2e83d494c36307025dca2d3afc6b4d185f3a3453d06cc4fecd7094057
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
    cd '$(SOURCE_DIR)' && AS='$(PREFIX)/$(BUILD)/bin/nasm' '$(SOURCE_DIR)/configure'\
        $(MXE_CONFIGURE_OPTS) \
        --cross-prefix='$(TARGET)'- \
        --disable-lavf \
        --disable-swscale \
        --enable-win32thread
    $(MAKE) -C '$(SOURCE_DIR)' -j 1 uninstall
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(SOURCE_DIR)' -j 1 install
endef
