# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := openmpt
$(PKG)_WEBSITE  := https://lib.openmpt.org
$(PKG)_DESCR    := Tracker music module decoding library (MOD, XM, IT, S3M) with C and C++ API.
$(PKG)_VERSION  := 0.7.19
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3c619bb36b3d9cd10b5531ebb83cac7fe38386d0614f9bb1a9a758010bc162d1
$(PKG)_FILE     := lib$(PKG)-$($(PKG)_VERSION)+release.autotools.tar.gz
$(PKG)_URL      := https://lib.$(PKG).org/files/lib$(PKG)/src/$($(PKG)_FILE)
$(PKG)_SUBDIR   := lib$(PKG)-$($(PKG)_VERSION)+release.autotools
$(PKG)_DEPS     := cc zlib mpg123 ogg vorbis flac libsndfile portaudio

define $(PKG)_BUILD

	# Configure package
	cd "$(BUILD_DIR)" && "$(SOURCE_DIR)/configure" \
		$(MXE_CONFIGURE_OPTS) \
		--host="$(TARGET)" \
		--prefix="$(PREFIX)/$(TARGET)" \
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

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "lib$(PKG)" --cflags --libs`
endef
