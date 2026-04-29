# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := imath
$(PKG)_WEBSITE  := https://imath.readthedocs.io
$(PKG)_DESCR    := Imath is a C++ and python library of 2D and 3D vector, matrix, and math operations for computer graphics
$(PKG)_VERSION  := 3.2.2
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := b4275d83fb95521510e389b8d13af10298ed5bed1c8e13efd961d91b1105e462
$(PKG)_GH_CONF  := AcademySoftwareFoundation/Imath/tags,v
$(PKG)_DEPS     := cc boost

define $(PKG)_BUILD
	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DBUILD_TESTING=ON \
		-DBUILD_WEBSITE=OFF \
		-DIMATH_ENABLE_LARGE_STACK=OFF \
		-DIMATH_HALF_USE_LOOKUP_TABLE=ON \
		-DIMATH_INSTALL=ON \
		-DIMATH_INSTALL_PKG_CONFIG=ON \
		-DIMATH_INSTALL_SYM_LINK=ON \
		-DIMATH_USE_CLANG_TIDY=OFF \
		-DIMATH_USE_DEFAULT_VISIBILITY=OFF \
		-DIMATH_USE_NOEXCEPT=ON \
		-DPYBIND11=OFF \
		-DPYTHON=OFF \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "Imath" --cflags --libs`
endef
