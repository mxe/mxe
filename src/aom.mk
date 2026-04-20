# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := aom
$(PKG)_WEBSITE  := https://aomedia.org/
$(PKG)_DESCR    := AV1 Codec Library
$(PKG)_VERSION  := 3.13.3
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 446a4ae9741cb8f3eeb98c949d25f91b48cb2b8569cae975c4b737392e9024fc
$(PKG)_FILE     := lib$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_SUBDIR   := lib$(PKG)-$($(PKG)_VERSION)
$(PKG)_URL      := https://storage.googleapis.com/$(PKG)-releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc pkgconf pthreads yasm

define $(PKG)_BUILD

	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DENABLE_ARM_CRC32=ON \
		-DENABLE_AVX2=ON \
		-DENABLE_AVX512=ON \
		-DENABLE_AVX=ON \
		-DENABLE_CCACHE=OFF \
		-DENABLE_DECODE_PERF_TESTS=OFF \
		-DENABLE_DISTCC=OFF \
		-DENABLE_DOCS=ON \
		-DENABLE_ENCODE_PERF_TESTS=OFF \
		-DENABLE_EXAMPLES=ON \
		-DENABLE_GOMA=OFF \
		-DENABLE_IDE_TEST_HOSTING=OFF \
		-DENABLE_MMX=ON \
		-DENABLE_NASM=OFF \
		-DENABLE_NEON=ON \
		-DENABLE_NEON_DOTPROD=ON \
		-DENABLE_NEON_I8MM=ON \
		-DENABLE_RVV=ON \
		-DENABLE_SSE2=ON \
		-DENABLE_SSE3=ON \
		-DENABLE_SSE4_1=ON \
		-DENABLE_SSE4_2=ON \
		-DENABLE_SSE=ON \
		-DENABLE_SSSE3=ON \
		-DENABLE_SVE2=ON \
		-DENABLE_SVE=ON \
		-DENABLE_TESTDATA=ON \
		-DENABLE_TESTS=ON \
		-DENABLE_TOOLS=ON \
		-DENABLE_VSX=ON \
		-DENABLE_WERROR=OFF \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "$(PKG)" --cflags --libs`
endef
