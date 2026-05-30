# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := opencv
$(PKG)_WEBSITE  := https://opencv.org/
$(PKG)_DESCR    := OpenCV
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.13.0
$(PKG)_CHECKSUM := 1d40ca017ea51c533cf9fd5cbde5b5fe7ae248291ddf2af99d4c17cf8e13017d
$(PKG)_GH_CONF  := opencv/opencv/releases
$(PKG)_DEPS     := cc eigen ffmpeg jasper jpeg libpng libwebp \
                   openblas openexr protobuf tiff xz zlib

# -DCMAKE_CXX_STANDARD=98 required for non-posix gcc7 build

define $(PKG)_BUILD
    # Fix CMake 4+ compatibility
    $(SED) -i 's/cmake_minimum_required([^)]*)/cmake_minimum_required(VERSION 3.5)/g' '$(SOURCE_DIR)/CMakeLists.txt' '$(SOURCE_DIR)'/cmake/*.cmake || true
    # build
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
      -DCMAKE_CXX_STANDARD=17 \
      -DWITH_QT=OFF \
      -DWITH_OPENGL=ON \
      -DWITH_GSTREAMER=OFF \
      -DWITH_GTK=OFF \
      -DWITH_VIDEOINPUT=ON \
      -DWITH_XINE=OFF \
      -DWITH_LAPACK=OFF \
      -DBUILD_opencv_apps=OFF \
      -DBUILD_DOCS=OFF \
      -DBUILD_EXAMPLES=OFF \
      -DBUILD_PACKAGE=OFF \
      -DBUILD_PERF_TESTS=OFF \
      -DBUILD_TESTS=OFF \
      -DBUILD_WITH_DEBUG_INFO=OFF \
      -DBUILD_FAT_JAVA_LIB=OFF \
      -DBUILD_ZLIB=OFF \
      -DBUILD_TIFF=OFF \
      -DBUILD_JASPER=OFF \
      -DBUILD_JPEG=OFF \
      -DBUILD_WEBP=OFF \
      -DBUILD_PROTOBUF=OFF \
      -DPROTOBUF_UPDATE_FILES=ON \
      -DBUILD_PNG=OFF \
      -DBUILD_OPENEXR=OFF \
      -DCMAKE_VERBOSE=ON \
      -DOPENCV_GENERATE_PKGCONFIG=ON

    # install
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1

    $(INSTALL) -m755 '$(BUILD_DIR)/unix-install/opencv4.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig'

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -std=c++17 \
        '$(SOURCE_DIR)/samples/cpp/fback.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-opencv.exe' \
        `'$(TARGET)-pkg-config' opencv4 libavcodec libavformat libswscale --cflags --libs` -lwebp
endef
