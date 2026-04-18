# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := de265
$(PKG)_WEBSITE  := https://www.libde265.org/
$(PKG)_DESCR    := Open h.265 video codec implementation.
$(PKG)_VERSION  := 1.0.18
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3fe36dd137ead3cb8ceb067165897c8898076537b563d53be4983ff6f35d773d
$(PKG)_GH_CONF  := strukturag/libde265/tags,v
$(PKG)_DEPS     := cc pkgconf libjpeg-turbo sdl2

define $(PKG)_BUILD

	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DENABLE_DECODER=ON \
		-DENABLE_ENCODER=OFF \
		-DENABLE_INTERNAL_DEVELOPMENT_TOOLS=OFF \
		-DENABLE_SDL=ON \
		-DENABLE_SHERLOCK265=OFF \
		-DUSE_IWYU=OFF \
		-DWITH_FUZZERS=OFF \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" -DLIBDE265_STATIC_BUILD \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "lib$(PKG)" --cflags --libs`
endef
