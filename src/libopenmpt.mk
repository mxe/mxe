# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libopenmpt
$(PKG)_WEBSITE  := https://lib.openmpt.org
$(PKG)_DESCR    := libopenmpt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.7.11
$(PKG)_SUBDIR   := libopenmpt-$($(PKG)_VERSION)+release.autotools
$(PKG)_FILE     := libopenmpt-$($(PKG)_VERSION)+release.autotools.tar.gz
$(PKG)_URL      := https://lib.openmpt.org/files/libopenmpt/src/$($(PKG)_FILE)
$(PKG)_CHECKSUM := a3e85e49c71633513369a473489895c104279b9087c5545598f45a0d33e9b110
$(PKG)_DEPS     := cc zlib mpg123 libogg libvorbis flac libsndfile portaudio

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-shared \
        --enable-static \
        --disable-examples \
        --disable-openmpt123 \
        --with-zlib \
        --with-mpg123 \
        --with-ogg \
        --with-vorbis \
        --with-flac \
        --with-sndfile \
        --with-portaudio \
        --without-sdl \
        --without-sdl2
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
