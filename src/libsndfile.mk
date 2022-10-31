# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsndfile
$(PKG)_VERSION  := 1.1.0
$(PKG)_CHECKSUM := 0f98e101c0f7c850a71225fb5feaf33b106227b3d331333ddc9bacee190bcf41
$(PKG)_GH_CONF  := libsndfile/libsndfile/releases/latest,,,,,.tar.xz
$(PKG)_DEPS     := cc flac ogg vorbis opus

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-sqlite \
        --enable-external-libs \
        --disable-octave \
        --disable-alsa \
        --disable-shave \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)
endef
