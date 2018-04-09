# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := openscenegraph
$(PKG)_WEBSITE  := http://www.openscenegraph.org/
$(PKG)_DESCR    := OpenSceneGraph
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.5.9
$(PKG)_CHECKSUM := 01cdfa34c525be76bb3c5e3e2c0f91346a6f6287b05ddfb6b9d15f96fd0c812e
$(PKG)_FILE     := OpenSceneGraph-$($(PKG)_VERSION).zip
$(PKG)_SUBDIR   := OpenSceneGraph-OpenSceneGraph-$($(PKG)_VERSION)
$(PKG)_URL      := https://github.com/openscenegraph/OpenSceneGraph/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := cc boost curl dcmtk freetype gdal giflib gstreamer \
                   gta jasper jpeg libpng openal openexr openthreads poppler \
                   qtbase tiff zlib

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMAKE_CXX_FLAGS='-D__STDC_CONSTANT_MACROS -D__STDC_LIMIT_MACROS' \
        -DCMAKE_HAVE_PTHREAD_H=OFF \
        -DPKG_CONFIG_EXECUTABLE='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        -DDYNAMIC_OPENTHREADS=$(CMAKE_SHARED_BOOL) \
        -DDYNAMIC_OPENSCENEGRAPH=$(CMAKE_SHARED_BOOL) \
        -DBUILD_OSG_APPLICATIONS=OFF \
        -DPOPPLER_HAS_CAIRO_EXITCODE=0 \
        -D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS_EXITCODE=1 \
        -D_OPENTHREADS_ATOMIC_USE_WIN32_INTERLOCKED=1 \
        $(if $(filter qtbase,$($(PKG)_DEPS)), \
          -DDESIRED_QT_VERSION=5, \
          -DDESIRED_QT_VERSION=4)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef
