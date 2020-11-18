# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsndfile
$(PKG)_VERSION  := 1.0.28
$(PKG)_CHECKSUM := 1ff33929f042fa333aed1e8923aa628c3ee9e1eb85512686c55092d1e5a9dfa9
$(PKG)_GH_CONF  := libsndfile/libsndfile/releases,v,,,,.tar.bz2
$(PKG)_DEPS     := cc flac ogg vorbis

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi -IM4
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-sqlite \
        --enable-external-libs \
        --disable-octave \
        --disable-alsa \
        --disable-shave \
        LIBS="`$(TARGET)-pkg-config --libs vorbis ogg`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_CRUFT)
endef
