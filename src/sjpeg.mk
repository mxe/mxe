# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

include src/common/pkgconfig-generator.mk

PKG             := sjpeg
$(PKG)_WEBSITE  := https://github.com/webmproject/sjpeg.git
$(PKG)_DESCR    := Lightweight JPEG encoder with simple C API and optional C++ interface
# Using main branch because there are no tags yet (https://github.com/webmproject/sjpeg/issues/145)
$(PKG)_VERSION  := main
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 9a427a1002b4597010495e18057073a564b3cba3fcb697bd518563ef95c2ecce
$(PKG)_GH_CONF  := webmproject/sjpeg/tags
$(PKG)_DEPS     := cc jpeg libpng

define $(PKG)_BUILD

	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DSJPEG_BUILD_EXAMPLES=OFF \
		-DSJPEG_ENABLE_SIMD=ON \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# Generate pkg-config (.pc) file for sjpeg (https://github.com/webmproject/sjpeg/issues/143)
	$(call GENERATE_PC, \
		$(PREFIX)/$(TARGET), \
		$(PKG), \
		$($(PKG)_DESCR), \
		$($(PKG)_VERSION), \
        , \
		libjpeg libpng, \
		-lsjpeg, \
	)

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "$(PKG)" --cflags --libs`
endef
