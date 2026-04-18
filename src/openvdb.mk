# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

include src/common/pkgconfig-generator.mk

PKG             := openvdb
$(PKG)_WEBSITE  := http://www.openvdb.org/
$(PKG)_DESCR    := OpenVDB - Sparse volume data structure and tools
$(PKG)_VERSION  := 13.0.0
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 4d6a91df5f347017496fe8d22c3dbb7c4b5d7289499d4eb4d53dd2c75bb454e1
$(PKG)_GH_CONF  := AcademySoftwareFoundation/openvdb/tags,v
$(PKG)_DEPS     := cc blosc boost glew imath libjpeg-turbo jemalloc openexr libpng pkgconf onetbb pthreads zlib glfw3

define $(PKG)_BUILD

	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DDISABLE_CMAKE_SEARCH_PATHS=OFF \
		-DDISABLE_DEPENDENCY_VERSION_CHECKS=OFF \
		-DMSVC_COMPRESS_PDB=OFF \
		-DOPENVDB_BUILD_AX=OFF \
		-DOPENVDB_BUILD_AX_UNITTESTS=OFF \
		-DOPENVDB_BUILD_BINARIES=ON \
		-DOPENVDB_BUILD_CORE=ON \
		-DOPENVDB_BUILD_DOCS=OFF \
		-DOPENVDB_BUILD_HOUDINI_ABITESTS=OFF \
		-DOPENVDB_BUILD_HOUDINI_PLUGIN=OFF \
		-DOPENVDB_BUILD_MAYA_PLUGIN=OFF \
		-DOPENVDB_BUILD_NANOVDB=OFF \
		-DOPENVDB_BUILD_PYTHON_MODULE=OFF \
		-DOPENVDB_BUILD_UNITTESTS=OFF \
		-DOPENVDB_CORE_SHARED=ON \
		-DOPENVDB_CORE_STATIC=ON \
		-DOPENVDB_CXX_STRICT=OFF \
		-DOPENVDB_ENABLE_ASSERTS=OFF \
		-DOPENVDB_ENABLE_RPATH=ON \
		-DOPENVDB_ENABLE_UNINSTALL=ON \
		-DOPENVDB_FUTURE_DEPRECATION=ON \
		-DOPENVDB_INSTALL_CMAKE_MODULES=ON \
		-DOPENVDB_USE_DELAYED_LOADING=ON \
		-DOPENVDB_USE_DEPRECATED_ABI_11=OFF \
		-DOPENVDB_USE_DEPRECATED_ABI_12=OFF \
		-DOPENVDB_USE_FUTURE_ABI_14=OFF \
		-DUSE_AX=OFF \
		-DUSE_BLOSC=ON \
		-DUSE_CCACHE=ON \
		-DUSE_COLORED_OUTPUT=OFF \
		-DUSE_EXPLICIT_INSTANTIATION=ON \
		-DUSE_EXR=OFF \
		-DUSE_HOUDINI=OFF \
		-DUSE_IMATH_HALF=OFF \
		-DUSE_LOG4CPLUS=OFF \
		-DUSE_MAYA=OFF \
		-DUSE_NANOVDB=OFF \
		-DUSE_PKGCONFIG=ON \
		-DUSE_PNG=OFF \
		-DUSE_STATIC_DEPENDENCIES=OFF \
		-DUSE_TBB=ON \
		-DUSE_ZLIB=ON \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# Only needed if the project does not ship a .pc file
	$(call GENERATE_PC, \
		$(PREFIX)/$(TARGET), \
		$(PKG), \
		$($(PKG)_DESCR), \
		$($(PKG)_VERSION), \
		, \
		, \
		-lopenvdb, \
	)

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "$(PKG)" --cflags --libs`
endef
