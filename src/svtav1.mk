# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := svtav1
$(PKG)_WEBSITE  := https://gitlab.com/AOMediaCodec/SVT-AV1.git
$(PKG)_DESCR    := Scalable Video Technology for AV1 encoder library
$(PKG)_VERSION  := 4.1.0
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 6c4c0c44ff0ba3d136d6f57f3a707f9de8e9c866f50f809c1d22a43f0d8c9583
$(PKG)_FILE     := SVT-AV1-v$($(PKG)_VERSION).tar.gz
$(PKG)_SUBDIR   := SVT-AV1-v$($(PKG)_VERSION)
$(PKG)_URL      := https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc pthreads

define $(PKG)_BUILD

	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DCOMPILE_C_ONLY=OFF \
		-DLOG_QUIET=OFF \
		-DMINIMAL_BUILD=OFF \
		-DRTC_BUILD=OFF \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "SvtAv1Enc" --cflags --libs`
endef
