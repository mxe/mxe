# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsndfile
$(PKG)_VERSION  := 1.2.2
$(PKG)_CHECKSUM := 3799ca9924d3125038880367bf1468e53a1b7e3686a934f098b7e1d286cdb80e
$(PKG)_GH_CONF  := libsndfile/libsndfile/releases/latest,,,,,.tar.xz
$(PKG)_DEPS     := cc flac ogg vorbis opus

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi
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
