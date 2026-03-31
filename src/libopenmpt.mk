# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libopenmpt
$(PKG)_WEBSITE  := https://lib.openmpt.org
$(PKG)_DESCR    := libopenmpt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.7.19
$(PKG)_SUBDIR   := libopenmpt-$($(PKG)_VERSION)+release.autotools
$(PKG)_FILE     := libopenmpt-$($(PKG)_VERSION)+release.autotools.tar.gz
$(PKG)_URL      := https://lib.openmpt.org/files/libopenmpt/src/$($(PKG)_FILE)
$(PKG)_CHECKSUM := 3c619bb36b3d9cd10b5531ebb83cac7fe38386d0614f9bb1a9a758010bc162d1
$(PKG)_DEPS     := cc zlib mpg123 ogg vorbis flac libsndfile portaudio

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
define $(PKG)_TEST
    $(TARGET)-gcc \
        -Werror -Wextra -Wall -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libopenmpt.exe' \
        `$(TARGET)-pkg-config libopenmpt --cflags --libs`
endef