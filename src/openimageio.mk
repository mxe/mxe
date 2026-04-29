# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := openimageio
$(PKG)_WEBSITE  := https://openimageio.readthedocs.org
$(PKG)_DESCR    := Reading, writing, and processing images in a wide variety of file formats, using a format-agnostic API, aimed at VFX applications.
$(PKG)_VERSION  := 3.1.12.0
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 24aa5a7af5c7a98887a8f495e18079d82ef73913370e906fa5d73016d37964c7
$(PKG)_GH_CONF  := AcademySoftwareFoundation/OpenImageIO/tags,v
$(PKG)_DEPS     := cc bzip2 boost dcmtk ffmpeg freetype giflib imath libjpeg-turbo jxl jasper libraw heif opencolorio openexr openjpeg openvdb libpng pkgconf ptex robin-map onetbb tiff pthreads libwebp zlib expat fmt libdeflate uhdr minizip-ng openjph pystring libyaml

define $(PKG)_BUILD

	# ======================================================================
	# Many modern CMake packages (including OpenImageIO) expect imported
	# targets like AOM::aom or zstd::libzstd or LibLZMA::LibLZMA.
	#
	# MXE provides these libraries, but does not always export matching
	# CMake targets. These shims define the missing targets so CMake
	# configuration can proceed without modifying upstream projects.
	#
	# Future improvement: replace with proper CMake package configs per
	# dependency where available.
	# ======================================================================

	printf '%s\n' \
	'if(NOT TARGET LibLZMA::LibLZMA)' \
	'    add_library(LibLZMA::LibLZMA STATIC IMPORTED GLOBAL)' \
	'    set_target_properties(LibLZMA::LibLZMA PROPERTIES' \
	'        IMPORTED_LOCATION "${CMAKE_PREFIX_PATH}/lib/liblzma.a"' \
	'    )' \
	'endif()' \
	'if(NOT TARGET zstd::libzstd)' \
	'    add_library(zstd::libzstd STATIC IMPORTED GLOBAL)' \
	'    set_target_properties(zstd::libzstd PROPERTIES' \
	'        IMPORTED_LOCATION "${CMAKE_PREFIX_PATH}/lib/libzstd.a"' \
	'    )' \
	'endif()' \
	'if(NOT TARGET AOM::aom)' \
	'    add_library(AOM::aom STATIC IMPORTED GLOBAL)' \
	'    set_target_properties(AOM::aom PROPERTIES' \
	'        IMPORTED_LOCATION "${CMAKE_PREFIX_PATH}/lib/libaom.a"' \
	'    )' \
	'endif()' \
	> "$(BUILD_DIR)/mxe-cmake-shims.cmake"

	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_PROJECT_TOP_LEVEL_INCLUDES="$(BUILD_DIR)/mxe-cmake-shims.cmake" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DCMAKE_C_FLAGS="-DJXL_STATIC_DEFINE" \
		-DCMAKE_CXX_FLAGS="-DJXL_STATIC_DEFINE" \
		-DOIIO_STATIC=ON \
		-DBUILD_DOCS=OFF \
		-DBUILD_OIIOUTIL_ONLY=OFF \
		-DCLANG_TIDY=OFF \
		-DCLANG_TIDY_FIX=OFF \
		-DCODECOV=OFF \
		-DEMBEDPLUGINS=ON \
		-DOIIO_BUILD_PLUGINS=OFF \
		-DENABLE_FAST_MATH=OFF \
		-DEXTRA_WARNINGS=OFF \
		-DIGNORE_HOMEBREWED_DEPS=OFF \
		-DINSTALL_DOCS=OFF \
		-DINSTALL_FONTS=OFF \
		-DLINKSTATIC=ON \
		-DOIIO_BUILD_PROFILER=OFF \
		-DOIIO_BUILD_TESTS=OFF \
		-DOIIO_BUILD_TOOLS=OFF \
		-DOIIO_INNER_NAMESPACE_INCLUDE_PATCH=OFF \
		-DOIIO_THREAD_ALLOW_DCLP=ON \
		-DPYLIB_INCLUDE_SONAME=OFF \
		-DPYLIB_LIB_PREFIX=OFF \
		-DSTOP_ON_WARNING=OFF \
		-DTIME_COMMANDS=OFF \
		-DUSE_CCACHE=ON \
		-DUSE_LIBCPLUSPLUS=OFF \
		-DUSE_PYTHON=OFF \
		-DVERBOSE=OFF \
		-DVISIBILITY_INLINES_HIDDEN=ON \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "OpenImageIO" --cflags --libs`
	cp "$(SOURCE_DIR)/testsuite/common/checker_with_alpha.exr" "$(PREFIX)/$(TARGET)/bin/"
endef
