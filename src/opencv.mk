# This file is part of MXE.
# See index.html for further information.

# OpenCV - Open Source Computer Vision
PKG             := opencv
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 6e518c0274a8392c0c98d18ef0ef754b9c596aca
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := OpenCV-$($(PKG)_VERSION)a.tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)library/$(PKG)-unix/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc eigen ffmpeg jasper jpeg lcms1 libpng openexr tiff xz zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # build
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
      -DWITH_QT=OFF \
      -DWITH_OPENGL=ON \
      -DWITH_GSTREAMER=OFF \
      -DWITH_GTK=OFF \
      -DWITH_VIDEOINPUT=ON \
      -DWITH_XINE=OFF \
      -DBUILD_SHARED_LIBS=OFF \
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
      -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
      '$(1)'

    # install
    $(MAKE) -C '$(1).build' -j '$(JOBS)' install VERBOSE=1

    # fixup and install pkg-config file
    # can't figure out where these unprefixed libs are coming from
    $(SED) -i 's,\(opengl32\|glu32\|stdc++\),-l\1,g' '$(1).build/unix-install/opencv.pc'
    $(INSTALL) -m755 '$(1).build/unix-install/opencv.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig'

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(1)/samples/c/fback_c.c' -o '$(PREFIX)/$(TARGET)/bin/test-opencv.exe' \
        `'$(TARGET)-pkg-config' opencv --cflags --libs`
endef
