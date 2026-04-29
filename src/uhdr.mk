# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

include src/common/pkgconfig-generator.mk

PKG             := uhdr
$(PKG)_WEBSITE  := https://developer.android.com/guide/topics/media/platform/hdr-image-format
$(PKG)_DESCR    := Ultra HDR is a true HDR image format, and is backcompatible.  libultrahdr is the reference codec for the Ultra HDR format.  The codecs that support the format can render the HDR intent of the image on HDR displays;  other codecs can still decode and display the SDR intent of the image.
$(PKG)_VERSION  := 1.4.0
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := e7e1252e2c44d8ed6b99ee0f67a3caf2d8a61c43834b13b1c3cd485574c03ab9
$(PKG)_GH_CONF  := google/libultrahdr/tags,v
$(PKG)_DEPS     := cc libjpeg-turbo pthreads mesa

define $(PKG)_BUILD
	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DUHDR_BUILD_BENCHMARK=OFF \
		-DUHDR_BUILD_DEPS=OFF \
		-DUHDR_BUILD_EXAMPLES=OFF \
		-DUHDR_BUILD_FUZZERS=OFF \
		-DUHDR_BUILD_JAVA=OFF \
		-DUHDR_BUILD_PACKAGING=OFF \
		-DUHDR_BUILD_TESTS=OFF \
		-DUHDR_ENABLE_GLES=OFF \
		-DUHDR_ENABLE_INSTALL=ON \
		-DUHDR_ENABLE_INTRINSICS=ON \
		-DUHDR_ENABLE_LOGS=OFF \
		-DUHDR_ENABLE_WERROR=OFF \
		-DUHDR_WRITE_ISO=ON \
		-DUHDR_WRITE_XMP=OFF \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)

    # Manual installation (CMake installing rules are missing)
    $(INSTALL) -d "$(PREFIX)/$(TARGET)/lib"
    $(INSTALL) -d "$(PREFIX)/$(TARGET)/include"

    $(INSTALL) -m 644 "$(BUILD_DIR)/libuhdr.a" "$(PREFIX)/$(TARGET)/lib/"
    $(INSTALL) -m 644 "$(BUILD_DIR)/libcore.a" "$(PREFIX)/$(TARGET)/lib/"
    $(INSTALL) -m 644 "$(BUILD_DIR)/libimage_io.a" "$(PREFIX)/$(TARGET)/lib/"
	$(INSTALL) -m 644 "$(SOURCE_DIR)/ultrahdr_api.h" "$(PREFIX)/$(TARGET)/include/"

	# Only needed if the project does not ship a .pc file
	$(call GENERATE_PC, \
		$(PREFIX)/$(TARGET), \
		$(PKG), \
		$($(PKG)_DESCR), \
		$($(PKG)_VERSION), \
		, \
		libjpeg pthreads, \
		-luhdr, \
	)

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "$(PKG)" --cflags --libs`
endef
