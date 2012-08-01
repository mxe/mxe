# This file is part of MXE.
# See index.html for further information.

# OpenCV
PKG             := opencv
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 96ff27b87e0f028d1d16201afebabec4e0c72367
$(PKG)_SUBDIR   := OpenCV-$($(PKG)_VERSION)
$(PKG)_FILE     := OpenCV-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/opencvlibrary/opencv-unix/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc bzip2 ffmpeg zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_EXAMPLES=ON \
        -DINSTALL_C_EXAMPLES=ON \
        -DWITH_OPENEXR=OFF \
        -DWITH_FFMPEG=ON \
        -DOPENCV_MODULE_TYPE=STATIC \
        -DBUILD_SHARED_LIBRARIES=OFF
    $(MAKE) -C '$(1)' -j '$(JOBS)' install VERBOSE=1
endef
