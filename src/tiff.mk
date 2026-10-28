# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := tiff
$(PKG)_WEBSITE  := https://download.osgeo.org/libtiff/
$(PKG)_DESCR    := LibTIFF
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.7.2
$(PKG)_CHECKSUM := 4996f0c4f93094719b1ca5c6279b20e588773ba8a247533e486416fb662ddb88
$(PKG)_SUBDIR   := tiff-$($(PKG)_VERSION)
$(PKG)_FILE     := tiff-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.osgeo.org/libtiff/$($(PKG)_FILE)
$(PKG)_DEPS     := cc jpeg zlib
$(PKG)_DEPS_SHARED := $($(PKG)_DEPS_$(BUILD)) libdeflate libwebp xz zstd

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.osgeo.org/libtiff/' | \
    $(SED) -n 's,.*>tiff-\([0-9][^<]*\)\.tar\.xz<.*,\1,p' | \
    grep -v 'alpha\|beta\|rc\|sig' | \
    tail -1
endef

define $(PKG)_BUILD
    '$(TARGET)-cmake' -S '$(SOURCE_DIR)' -B $(BUILD_DIR) \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -Djpeg-prefer-standard[=ON \
        -Dtiff-static=$(CMAKE_STATIC_BOOL) \
        -Dtiff-{tools,tests,contrib,docs}=OFF \
        -D{libdeflate,lzma,webp,zstd}=$(CMAKE_SHARED_BOOL) \
        $(PKG_CMAKE_OPTS)
    '$(TARGET)-cmake' --build '$(BUILD_DIR)' --parallel '$(JOBS)'
    '$(TARGET)-cmake' --install '$(BUILD_DIR)'
endef
