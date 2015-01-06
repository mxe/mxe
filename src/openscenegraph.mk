# This file is part of MXE.
# See index.html for further information.

PKG             := openscenegraph
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.0
$(PKG)_CHECKSUM := c20891862b5876983d180fc4a3d3cfb2b4a3375c
$(PKG)_SUBDIR   := OpenSceneGraph-$($(PKG)_VERSION)
$(PKG)_FILE     := OpenSceneGraph-$($(PKG)_VERSION).zip
$(PKG)_URL      := http://www.openscenegraph.org/downloads/developer_releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc boost curl dcmtk ffmpeg freetype gdal giflib gta jasper jpeg libpng openal openexr poppler qt tiff xine-lib zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.openscenegraph.org/downloads/developer_releases/?C=M;O=D' | \
    $(SED) -n 's,.*OpenSceneGraph-\([0-9]*\.[0-9]*[02468]\.[^<]*\)\.zip.*,\1,p' | \
    grep -v rc | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_CXX_FLAGS=-D__STDC_CONSTANT_MACROS \
        -DCMAKE_HAVE_PTHREAD_H=OFF \
        -DPKG_CONFIG_EXECUTABLE='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        -DDYNAMIC_OPENTHREADS=OFF \
        -DDYNAMIC_OPENSCENEGRAPH=OFF \
        -DBUILD_OSG_APPLICATIONS=OFF \
        -DPOPPLER_HAS_CAIRO_EXITCODE=0 \
        -D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS_EXITCODE=1
    $(MAKE) -C '$(1)' -j '$(JOBS)' install VERBOSE=1
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =
$(PKG)_BUILD_i686-w64-mingw32 =

$(PKG)_BUILD_SHARED =
