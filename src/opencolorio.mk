# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

include src/common/pkgconfig-generator.mk

PKG             := opencolorio
$(PKG)_WEBSITE  := https://opencolorio.org
$(PKG)_DESCR    := A color management framework for visual effects and animation.
$(PKG)_VERSION  := 2.5.1
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 08cb6213ea4edee550ab050509d38204004bee6742c658166b1cf825d0a9381b
$(PKG)_GH_CONF  := AcademySoftwareFoundation/OpenColorIO/tags,v
$(PKG)_DEPS     := cc imath minizip-ng pkgconf expat yaml-cpp bzip2 lzma zstd pystring zlib openexr

define $(PKG)_BUILD

	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DBUILD_TESTING=ON \
		-DOCIO_BUILD_APPS=ON \
		-DOCIO_BUILD_DOCS=OFF \
		-DOCIO_BUILD_GPU_TESTS=ON \
		-DOCIO_BUILD_JAVA=OFF \
		-DOCIO_BUILD_NUKE=OFF \
		-DOCIO_BUILD_OPENFX=OFF \
		-DOCIO_BUILD_PYTHON=OFF \
		-DOCIO_BUILD_TESTS=ON \
		-DOCIO_ENABLE_SANITIZER=OFF \
		-DOCIO_USE_AVX2=ON \
		-DOCIO_USE_AVX512=ON \
		-DOCIO_USE_AVX=ON \
		-DOCIO_USE_F16C=ON \
		-DOCIO_USE_HEADLESS=OFF \
		-DOCIO_USE_OIIO_FOR_APPS=OFF \
		-DOCIO_USE_SIMD=ON \
		-DOCIO_USE_SOVERSION=ON \
		-DOCIO_USE_SSE2=ON \
		-DOCIO_USE_SSE3=ON \
		-DOCIO_USE_SSE42=ON \
		-DOCIO_USE_SSE4=ON \
		-DOCIO_USE_SSSE3=ON \
		-DOCIO_VERBOSE=OFF \
		-DOCIO_WARNING_AS_ERROR=OFF \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# OCIO's original OpenColorIO.pc is incomplete, so overwriting .pc
	rm $(PREFIX)/$(TARGET)/lib/pkgconfig/OpenColorIO.pc
	$(call GENERATE_PC, \
		$(PREFIX)/$(TARGET), \
		OpenColorIO, \
		$($(PKG)_DESCR), \
		$($(PKG)_VERSION), \
		expat yaml-cpp, \
		Imath minizip zlib liblzma libzstd pystring, \
		-lOpenColorIO, \
		-lbz2 -lbcrypt -lgdi32, \
		, \
		-DOpenColorIO_SKIP_IMPORTS \
	)

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "OpenColorIO" --cflags --libs`
endef
