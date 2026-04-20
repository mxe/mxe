# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

include src/common/pkgconfig-generator.mk

PKG             := alembic
$(PKG)_WEBSITE  := http://alembic.io/
$(PKG)_DESCR    := Alembic is an open framework for storing and sharing scene data that includes a C++ library, a file format, and client plugins and applications.
$(PKG)_VERSION  := 1.8.11
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := ab299bb4b1894a6675c73fa29940522b54c81a91b1d691ca3470d86b7345ffce
$(PKG)_GH_CONF  := alembic/alembic/tags
$(PKG)_DEPS     := cc boost hdf5 imath pthreads zlib

define $(PKG)_BUILD

	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DALEMBIC_BUILD_LIBS=ON \
		-DALEMBIC_DEBUG_WARNINGS_AS_ERRORS=ON \
		-DALEMBIC_SHARED_LIBS=ON \
		-DDOCS_PATH=OFF \
		-DUSE_ARNOLD=OFF \
		-DUSE_BINARIES=ON \
		-DUSE_EXAMPLES=OFF \
		-DUSE_HDF5=ON \
		-DHDF5_ROOT="$(PREFIX)/$(TARGET)" \
		-DUSE_MAYA=OFF \
		-DUSE_PRMAN=OFF \
		-DUSE_PYALEMBIC=OFF \
		-DUSE_STATIC_BOOST=OFF \
		-DUSE_STATIC_HDF5=OFF \
		-DUSE_TESTS=ON \
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
		-lAlembic, \
	)

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "$(PKG)" --cflags --libs`
endef
