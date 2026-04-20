# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := jxl
$(PKG)_WEBSITE  := https://jpeg.org/jpegxl/
$(PKG)_DESCR    := JPEG XL image format reference implementation
$(PKG)_VERSION  := 0.11.2
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := ab38928f7f6248e2a98cc184956021acb927b16a0dee71b4d260dc040a4320ea
$(PKG)_GH_CONF  := libjxl/libjxl/tags,v
$(PKG)_DEPS     := cc brotli sjpeg giflib libjpeg-turbo libpng pkgconf pthreads highway lcms openexr zlib

define $(PKG)_BUILD

	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DBUILD_TESTING=OFF \
		-DJPEGXL_BUNDLE_LIBPNG=NO \
		-DJPEGXL_ENABLE_AVX512=false \
		-DJPEGXL_ENABLE_AVX512_SPR=false \
		-DJPEGXL_ENABLE_AVX512_ZEN4=false \
		-DJPEGXL_ENABLE_BENCHMARK=false \
		-DJPEGXL_ENABLE_BOXES=false \
		-DJPEGXL_ENABLE_COVERAGE=false \
		-DJPEGXL_ENABLE_DEVTOOLS=false \
		-DJPEGXL_ENABLE_DOXYGEN=false \
		-DJPEGXL_ENABLE_EXAMPLES=false \
		-DJPEGXL_ENABLE_JNI=false \
		-DJPEGXL_ENABLE_JPEGLI=NO \
		-DJPEGXL_ENABLE_JPEGLI_LIBJPEG=false \
		-DJPEGXL_ENABLE_MANPAGES=false \
		-DJPEGXL_ENABLE_OPENEXR=false \
		-DJPEGXL_ENABLE_PLUGINS=false \
		-DJPEGXL_ENABLE_SIZELESS_VECTORS=false \
		-DJPEGXL_ENABLE_SJPEG=false \
		-DJPEGXL_ENABLE_SKCMS=NO \
		-DJPEGXL_ENABLE_TOOLS=true \
		-DJPEGXL_ENABLE_TRANSCODE_JPEG=false \
		-DJPEGXL_ENABLE_VIEWERS=false \
		-DJPEGXL_ENABLE_WASM_THREADS=false \
		-DJPEGXL_FORCE_NEON=false \
		-DJPEGXL_FORCE_SYSTEM_BROTLI=true \
		-DJPEGXL_FORCE_SYSTEM_GTEST=false \
		-DJPEGXL_FORCE_SYSTEM_HWY=true \
		-DJPEGXL_FORCE_SYSTEM_LCMS2=true \
		-DJPEGXL_INSTALL_JPEGLI_LIBJPEG=false \
		-DJPEGXL_STATIC=true \
		-DJPEGXL_TEST_TOOLS=false \
		-DJPEGXL_WARNINGS_AS_ERRORS=false \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "lib$(PKG)" --cflags --libs`
endef
