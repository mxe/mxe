# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := highway
$(PKG)_WEBSITE  := https://google.github.io/highway/
$(PKG)_DESCR    := C++ library that provides portable SIMD/vector intrinsics
$(PKG)_VERSION  := 1.3.0
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 07b3c1ba2c1096878a85a31a5b9b3757427af963b1141ca904db2f9f4afe0bc2
$(PKG)_GH_CONF  := google/highway/tags
$(PKG)_DEPS     := cc pthreads

define $(PKG)_BUILD

	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DBUILD_GMOCK=ON \
		-DBUILD_TESTING=OFF \
		-DHWY_CMAKE_ARM7=OFF \
		-DHWY_CMAKE_HEADER_ONLY=OFF \
		-DHWY_CMAKE_LASX=ON \
		-DHWY_CMAKE_LSX=ON \
		-DHWY_CMAKE_RVV=ON \
		-DHWY_CMAKE_SSE2=OFF \
		-DHWY_DISABLE_FUTEX=OFF \
		-DHWY_ENABLE_CONTRIB=OFF \
		-DHWY_ENABLE_EXAMPLES=OFF \
		-DHWY_ENABLE_INSTALL=ON \
		-DHWY_ENABLE_TESTS=OFF \
		-DHWY_FORCE_STATIC_LIBS=ON \
		-DHWY_SYSTEM_GTEST=OFF \
		-DHWY_TEST_STANDALONE=OFF \
		-DHWY_WARNINGS_ARE_ERRORS=OFF \
		-DINSTALL_GTEST=ON \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "libhwy" --cflags --libs`
endef
