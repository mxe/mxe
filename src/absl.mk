# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := absl
$(PKG)_WEBSITE  := https://abseil.io
$(PKG)_DESCR    := Abseil C++ Common utility library for Google-style C++ development
$(PKG)_VERSION  := 20260107.1
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 4314e2a7cbac89cac25a2f2322870f343d81579756ceff7f431803c2c9090195
$(PKG)_GH_CONF  := abseil/abseil-cpp/tags
$(PKG)_DEPS     := cc pthreads

define $(PKG)_BUILD

	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DABSL_BUILD_MONOLITHIC_SHARED_LIBS=ON \
		-DABSL_BUILD_TESTING=OFF \
		-DABSL_BUILD_TEST_HELPERS=OFF \
		-DABSL_ENABLE_INSTALL=ON \
		-DABSL_MSVC_STATIC_RUNTIME=OFF \
		-DABSL_PROPAGATE_CXX_STD=ON \
		-DABSL_USE_EXTERNAL_GOOGLETEST=OFF \
		-DABSL_USE_GOOGLETEST_HEAD=OFF \
		-DABSL_USE_SYSTEM_INCLUDES=OFF \
		-DBUILD_TESTING=ON \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "$(PKG)_base" "$(PKG)_strings" --cflags --libs`
endef
