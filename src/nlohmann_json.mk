# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := nlohmann_json
$(PKG)_WEBSITE  := https://json.nlohmann.me
$(PKG)_DESCR    := JSON for Modern C++
$(PKG)_VERSION  := 3.12.0
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 4b92eb0c06d10683f7447ce9406cb97cd4b453be18d7279320f7b2f025c10187
$(PKG)_GH_CONF  := nlohmann/json/tags,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DBUILD_TESTING=ON \
		-DJSON_CI=OFF \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "$(PKG)" --cflags --libs`
endef
