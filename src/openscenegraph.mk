# This file is part of MXE.
# See index.html for further information.

PKG             := openscenegraph
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.0
$(PKG)_CHECKSUM := 5c727d84755da276adf8c4a4a3a8ba9c9570fc4b4969f06f1d2e9f89b1e3040e
$(PKG)_SUBDIR   := OpenSceneGraph-$($(PKG)_VERSION)
$(PKG)_FILE     := OpenSceneGraph-$($(PKG)_VERSION).zip
$(PKG)_URL      := http://trac.openscenegraph.org/downloads/developer_releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc boost curl dcmtk ffmpeg freetype gdal giflib gta jasper jpeg libpng openal openexr poppler qt tiff xine-lib zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://trac.openscenegraph.org/downloads/developer_releases/?C=M;O=D' | \
    $(SED) -n 's,.*OpenSceneGraph-\([0-9]*\.[0-9]*[02468]\.[^<]*\)\.zip.*,\1,p' | \
    grep -v rc | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake '$(1)' \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_CXX_FLAGS='-D__STDC_CONSTANT_MACROS' \
        -DCMAKE_HAVE_PTHREAD_H=OFF \
        -DPKG_CONFIG_EXECUTABLE='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        -DDYNAMIC_OPENTHREADS=$(CMAKE_SHARED_BOOL) \
        -DDYNAMIC_OPENSCENEGRAPH=$(CMAKE_SHARED_BOOL) \
        -DBUILD_OSG_APPLICATIONS=OFF \
        -DPOPPLER_HAS_CAIRO_EXITCODE=0 \
        -D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS_EXITCODE=1 \
        -D_OPENTHREADS_ATOMIC_USE_WIN32_INTERLOCKED=1
    $(MAKE) -C '$(1).build' -j '$(JOBS)' install VERBOSE=1
endef
