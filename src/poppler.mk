# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := poppler
$(PKG)_WEBSITE  := https://poppler.freedesktop.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 20.08.0
$(PKG)_CHECKSUM := ae65fef04bbf63259a6352e7b620719115d4fb97f5079b0b8b00a8eb0c86eca5
$(PKG)_SUBDIR   := poppler-$($(PKG)_VERSION)
$(PKG)_FILE     := poppler-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://poppler.freedesktop.org/$($(PKG)_FILE)
$(PKG)_DEPS     := cc cairo curl freetype glib jpeg lcms libpng libwebp openjpeg qtbase tiff zlib

define $(PKG)_UPDATE
    $(call GET_LATEST_VERSION, https://poppler.freedesktop.org/releases.html, poppler-)
endef

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
        -DENABLE_UNSTABLE_API_ABI_HEADERS=ON \
        -DENABLE_TESTS=OFF \
        -DBUILD_GTK_TESTS=OFF \
        -DBUILD_QT5_TESTS=OFF \
        -DBUILD_CPP_TESTS=OFF \
        -DENABLE_SPLASH=ON \
        -DENABLE_UTILS=OFF \
        -DENABLE_CPP=ON \
        -DENABLE_GLIB=ON \
        -DENABLE_GOBJECT_INTROSPECTION=OFF \
        -ENABLE_GTK_DOC=OFF \
        -DENABLE_QT5=ON \
        -DENABLE_LIBOPENJPEG=openjpeg2 \
        -DENABLE_CMS=lcms2 \
        -DENABLE_DCTDECODER=libjpeg \
        -DENABLE_LIBCURL=ON \
        -DENABLE_ZLIB=ON \
        -DENABLE_ZLIB_UNCOMPRESS=OFF \
        -DSPLASH_CMYK=ON \
        -DUSE_FIXEDPOINT=OFF \
        -DUSE_FLOAT=OFF \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DENABLE_RELOCATABLE=ON \
        -DEXTRA_WARN=OFF \
        -DFONT_CONFIGURATION=win32 \
        '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # compile test
    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic -std=c++11 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' poppler-cpp --cflags --libs`
endef
