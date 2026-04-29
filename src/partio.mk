# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

include src/common/pkgconfig-generator.mk

PKG             := partio
$(PKG)_WEBSITE  := https://www.disneyanimation.com/open-source/partio/
$(PKG)_DESCR    := C++ library for reading, writing, and manipulating common particle formats (PDB, BGEO, PTC), with optional Python bindings
$(PKG)_VERSION  := 1.20.0
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := e60a89364f2b5d9c9b1f143175fc1a5018027a59bb31af56e5df88806b506e49
$(PKG)_GH_CONF  := wdas/partio/tags,v
$(PKG)_DEPS     := cc freeglut pthreads zlib

define $(PKG)_BUILD

	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DBUILD_TESTING=OFF \
		-DPARTIO_BUILD_DOCS=ON \
		-DPARTIO_BUILD_PYTHON=OFF \
		-DPARTIO_BUILD_SHARED_LIBS=OFF \
		-DPARTIO_BUILD_TOOLS=OFF \
		-DPARTIO_ENABLE_TESTING=OFF \
		-DPARTIO_ORIGIN_RPATH=OFF \
		-DPARTIO_USE_GLVND=ON \
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
		pthreads zlib, \
		, \
		-lpartio -lz -lpthread \
	)

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "$(PKG)" --cflags --libs`
endef
