# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := uvg266
$(PKG)_WEBSITE  := https://ultravideo.fi/uvg266.html
$(PKG)_DESCR    := An open-source VVC encoder based on Kvazaar
$(PKG)_VERSION  := 0.8.1
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 9a2c68f94a1105058d1e654191036423d0a0fcf33b7e790dd63801997540b6ec
$(PKG)_GH_CONF  := ultravideo/uvg266/tags,v
$(PKG)_DEPS     := cc pthreads

define $(PKG)_BUILD
	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DBUILD_SHARED_LIBS=ON \
		-DBUILD_TESTS=ON \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "$(PKG)" --cflags --libs`
endef
