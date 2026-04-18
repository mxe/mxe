# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := heif
$(PKG)_WEBSITE  := https://github.com/strukturag/libheif.git
$(PKG)_DESCR    := libheif is an HEIF and AVIF file format decoder and encoder.
$(PKG)_VERSION  := 1.21.2
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 79996de959d28ca82ef070c382304683f5cdaf04cbe2953a74587160a3710a36
$(PKG)_GH_CONF  := strukturag/libheif/tags,v
$(PKG)_DEPS     := cc aom brotli dav1d ffmpeg de265 openjph openh264 openjpeg libpng svtav1 tiff pthreads uvg266 x264 x265 zlib kvazaar libwebp vvdec vvenc

# libsharpyuv is built and installed as part of libwebp

define $(PKG)_BUILD

	# Fix for issue: https://github.com/strukturag/libheif/issues/1756
	# On Windows, libheif must be built with LIBDE265_STATIC_BUILD to match the static libde265 build and avoid DLL import (__imp_de265_*) symbol mismatches.
	# This patch introduces target_compile_definitions(heif PRIVATE LIBDE265_STATIC_BUILD)

	cd "$(SOURCE_DIR)" && \
	FILE="CMakeLists.txt" && \
	grep -q LIBDE265_STATIC_BUILD "$$FILE" || \
	awk '\
	/add_library\(heif/ {\
		print;\
		print "target_compile_definitions(heif PRIVATE LIBDE265_STATIC_BUILD)";\
		next\
	}\
	{ print }\
	' "$$FILE" > "$$FILE.tmp" && \
	mv "$$FILE.tmp" "$$FILE"

	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DCMAKE_C_FLAGS="-DLIBDE265_STATIC_BUILD" \
		-DCMAKE_CXX_FLAGS="-DLIBDE265_STATIC_BUILD" \
		-DBUILD_DOCUMENTATION=ON \
		-DBUILD_TESTING=OFF \
		-DENABLE_COVERAGE=OFF \
		-DENABLE_EXPERIMENTAL_FEATURES=OFF \
		-DENABLE_EXPERIMENTAL_MINI_FORMAT=OFF \
		-DENABLE_MULTITHREADING_SUPPORT=ON \
		-DENABLE_PARALLEL_TILE_DECODING=ON \
		-DENABLE_PLUGIN_LOADING=OFF \
		-DWITH_AOM_DECODER=ON \
		-DWITH_AOM_DECODER_PLUGIN=OFF \
		-DWITH_AOM_ENCODER=ON \
		-DWITH_AOM_ENCODER_PLUGIN=OFF \
		-DWITH_DAV1D=ON \
		-DWITH_DAV1D_PLUGIN=OFF \
		-DWITH_EXAMPLES=OFF \
		-DWITH_EXAMPLE_HEIF_THUMB=OFF \
		-DWITH_EXAMPLE_HEIF_VIEW=OFF \
		-DWITH_FFMPEG_DECODER=OFF \
		-DWITH_FFMPEG_DECODER_PLUGIN=OFF \
		-DWITH_FUZZERS=OFF \
		-DWITH_GDK_PIXBUF=ON \
		-DWITH_HEADER_COMPRESSION=OFF \
		-DWITH_JPEG_DECODER=OFF \
		-DWITH_JPEG_DECODER_PLUGIN=OFF \
		-DWITH_JPEG_ENCODER=OFF \
		-DWITH_JPEG_ENCODER_PLUGIN=OFF \
		-DWITH_KVAZAAR=OFF \
		-DWITH_KVAZAAR_PLUGIN=OFF \
		-DLIBDE265_STATIC=ON \
		-DLIBDE265_DLL_IMPORT=OFF \
		-DWITH_LIBDE265=ON \
		-DWITH_LIBDE265_PLUGIN=OFF \
		-DWITH_LIBSHARPYUV=ON \
		-DWITH_LIBSHARPYUV_INTERNAL=OFF \
		-DWITH_OPENJPH_ENCODER=OFF \
		-DWITH_OPENJPH_ENCODER_PLUGIN=OFF \
		-DWITH_RAV1E=OFF \
		-DWITH_RAV1E_PLUGIN=OFF \
		-DWITH_REDUCED_VISIBILITY=ON \
		-DWITH_UNCOMPRESSED_CODEC=OFF \
		-DWITH_UVG266=OFF \
		-DWITH_UVG266_PLUGIN=OFF \
		-DWITH_VVDEC=OFF \
		-DWITH_VVDEC_PLUGIN=OFF \
		-DWITH_VVENC=OFF \
		-DWITH_VVENC_PLUGIN=OFF \
		-DWITH_WEBCODECS=OFF \
		-DWITH_X264=OFF \
		-DWITH_X264_PLUGIN=OFF \
		-DX265_STATIC_LIB=ON \
		-DWITH_X265=OFF \
		-DWITH_X265_PLUGIN=OFF \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install


	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "libheif" --cflags --libs`

	cp "$(SOURCE_DIR)/examples/example.heic" "$(PREFIX)/$(TARGET)/bin/"
endef
