# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := ptex
$(PKG)_WEBSITE  := https://ptex.us/
$(PKG)_DESCR    := Per-Face Texture Mapping for Production Rendering
$(PKG)_VERSION  := 2.5.2
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := dd95fbea4b50e9e68fd042f540fb83157a0ff25053066c3439d4527de3621d34
$(PKG)_GH_CONF  := wdas/ptex/tags,v
$(PKG)_DEPS     := cc pthreads zlib libdeflate

define $(PKG)_BUILD

	# Ptex installs its pkg-config file into share/pkgconfig, which is not
	# searched by MXE's pkg-config configuration. This causes downstream
	# builds (e.g. OpenImageIO) to fail with errors like:
	# "Package ptex was not found in the pkg-config search path."
	# We patch it to lib/pkgconfig so dependency discovery works correctly

	tmpfile="$(mktemp /tmp/ptex.cmake.XXXXXX)" && \
	$(SED) 's|DESTINATION share/pkgconfig|DESTINATION lib/pkgconfig|g' \
		"$(SOURCE_DIR)/src/build/CMakeLists.txt" > "$tmpfile" && \
	mv "$tmpfile" "$(SOURCE_DIR)/src/build/CMakeLists.txt"

	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DPTEX_BUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DPTEX_BUILD_STATIC_LIBS=$(CMAKE_STATIC_BOOL) \
		-DPTEX_BUILD_DOCS=OFF \
		-DPRMAN_15_COMPATIBLE_PTEX=OFF \
		-DBUILD_TESTING=OFF \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# Ptex library automatically builds a test utility:
	# $(PREFIX)/$(TARGET)/bin/ptxinfo.exe
endef
