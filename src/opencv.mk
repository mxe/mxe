# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := opencv
$(PKG)_WEBSITE  := http://opencv.org/
$(PKG)_DESCR    := OpenCV
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.10
$(PKG)_CHECKSUM := 1bf4cb87283797fd91669d4f90b622a677a903c20b4a577b7958a2164f7596c6
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := opencv-$($(PKG)_VERSION).zip
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)library/$(PKG)-unix/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://distfiles.macports.org/opencv/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc eigen ffmpeg jasper jpeg lcms1 libpng openexr tiff xz zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/opencvlibrary/files/opencv-unix/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # build
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
      -DWITH_QT=OFF \
      -DWITH_OPENGL=ON \
      -DWITH_GSTREAMER=OFF \
      -DWITH_GTK=OFF \
      -DWITH_VIDEOINPUT=ON \
      -DWITH_XINE=OFF \
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
      -DBUILD_PNG=OFF \
      -DBUILD_OPENEXR=OFF \
      -DCMAKE_VERBOSE=ON \
      -DCMAKE_CXX_FLAGS='-D_WIN32_WINNT=0x0500 -D__STDC_LIMIT_MACROS'

    # install
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1

    # fixup and install pkg-config file
    # openexr isn't available on x86_64-w64-mingw32
    # opencv builds it's own libIlmImf.a
    $(if $(findstring x86_64-w64-mingw32,$(TARGET)),\
        $(SED) -i 's/OpenEXR//' '$(BUILD_DIR)/unix-install/opencv.pc')
    $(SED) -i 's,share/OpenCV/3rdparty/,,g' '$(BUILD_DIR)/unix-install/opencv.pc'
    $(INSTALL) -m755 '$(BUILD_DIR)/unix-install/opencv.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig'

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(1)/samples/c/fback_c.c' -o '$(PREFIX)/$(TARGET)/bin/test-opencv.exe' \
        `'$(TARGET)-pkg-config' opencv --cflags --libs`
endef
