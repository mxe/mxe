# This file is part of MXE.
# See index.html for further information.

PKG             := opencv
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.8
$(PKG)_CHECKSUM := 7878a8c375ab3e292c8de7cb102bb3358056e01e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := opencv-$($(PKG)_VERSION).zip
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)library/$(PKG)-unix/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := http://distfiles.macports.org/opencv/$($(PKG)_FILE)
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
      -DCMAKE_CXX_FLAGS='-D_WIN32_WINNT=0x0500' \
      '$(1)'

    # install
    $(MAKE) -C '$(1).build' -j '$(JOBS)' install VERBOSE=1

    # fixup and install pkg-config file
    # openexr isn't available on x86_64-w64-mingw32
    # opencv builds it's own libIlmImf.a
    $(if $(findstring x86_64-w64-mingw32,$(TARGET)),\
        $(SED) -i 's/OpenEXR//' '$(1).build/unix-install/opencv.pc')
    $(SED) -i 's,share/OpenCV/3rdparty/,,g' '$(1).build/unix-install/opencv.pc'
    $(INSTALL) -m755 '$(1).build/unix-install/opencv.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig'

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(1)/samples/c/fback_c.c' -o '$(PREFIX)/$(TARGET)/bin/test-opencv.exe' \
        `'$(TARGET)-pkg-config' opencv --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
