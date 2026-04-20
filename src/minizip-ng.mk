# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

include src/common/pkgconfig-generator.mk

PKG             := minizip-ng
$(PKG)_WEBSITE  := https://www.winimage.com/zLibDll/minizip.html
$(PKG)_DESCR    := Modern fork of minizip providing ZIP archive handling with support for multiple compression backends zlib, bzip2, lzma, zstd
$(PKG)_VERSION  := 4.1.0
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 85417229bb0cd56403e811c316150eea1a3643346d9cec7512ddb7ea291b06f2
$(PKG)_GH_CONF  := zlib-ng/minizip-ng/tags
$(PKG)_DEPS     := cc bzip2 libiconv lzma openssl pkgconf zlib zstd xz

define $(PKG)_BUILD

	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DMZ_BUILD_FUZZ_TESTS=OFF \
		-DMZ_BUILD_TESTS=OFF \
		-DMZ_BUILD_UNIT_TESTS=OFF \
		-DMZ_BZIP2=ON \
		-DMZ_CODE_COVERAGE=OFF \
		-DMZ_COMPAT=ON \
		-DMZ_COMPRESS_ONLY=OFF \
		-DMZ_DECOMPRESS_ONLY=OFF \
		-DMZ_FETCH_LIBS=OFF \
		-DMZ_FILE32_API=OFF \
		-DMZ_FORCE_FETCH_LIBS=OFF \
		-DMZ_ICONV=ON \
		-DMZ_LIBBSD=ON \
		-DMZ_LZMA=ON \
		-DMZ_OPENSSL=ON \
		-DMZ_PKCRYPT=ON \
		-DMZ_WZAES=ON \
		-DMZ_ZLIB=ON \
		-DMZ_ZSTD=ON \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# compile upstream CLI (reference tool)
	'$(TARGET)-gcc' \
		-W -Wall -Werror -Wno-format \
		-DHAVE_STDINT_H -DHAVE_INTTYPES_H \
		'$(SOURCE_DIR)/minizip.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG)-cli.exe' \
		`'$(TARGET)-pkg-config' minizip --libs-only-l`

	# compile real-world test (API + pkg-config validation)
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG)-api.exe" \
		`"$(TARGET)-pkg-config" minizip --cflags --libs`
endef
