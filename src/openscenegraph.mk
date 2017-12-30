# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := openscenegraph
$(PKG)_WEBSITE  := http://www.openscenegraph.org/
$(PKG)_DESCR    := OpenSceneGraph
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.1
$(PKG)_CHECKSUM := 930eb46f05781a76883ec16c5f49cfb29a059421db131005d75bec4d78401fd5
#$(PKG)_GH_CONF  := openscenegraph/OpenSceneGraph/tags, OpenSceneGraph-
$(PKG)_SUBDIR   := OpenSceneGraph-OpenSceneGraph-$($(PKG)_VERSION)
$(PKG)_FILE     := OpenSceneGraph-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/openscenegraph/OpenSceneGraph/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := cc boost curl dcmtk freetype gdal giflib gstreamer \
                   gta jasper jpeg libpng openal openexr openthreads poppler \
                   qtbase tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.openscenegraph.org/index.php/download-section/stable-releases' | \
    $(SED) -n 's,.*OpenSceneGraph/tree/OpenSceneGraph-\([0-9]*\.[0-9]*[02468]\.[^<]*\)">.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

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
