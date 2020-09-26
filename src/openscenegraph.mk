# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := openscenegraph
$(PKG)_WEBSITE  := http://www.openscenegraph.org/
$(PKG)_DESCR    := OpenSceneGraph
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.6.4
$(PKG)_CHECKSUM := 81394d1b484c631028b85d21c5535280c21bbd911cb058e8746c87e93e7b9d33
$(PKG)_GH_CONF  := openscenegraph/OpenSceneGraph/tags, OpenSceneGraph-
$(PKG)_DEPS     := cc boost curl dcmtk freetype gdal giflib gstreamer \
                   gta jasper jpeg libpng openal openexr openthreads poppler \
                   tiff zlib

define $(PKG)_BUILD
    $(foreach PKG_PATCH,$(sort $(wildcard $(TOP_DIR)/src/openthreads-*.patch)),
        (cd '$(1)' && $(PATCH) -p1 -u) < $(PKG_PATCH))
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMAKE_CXX_FLAGS='-D__STDC_CONSTANT_MACROS -D__STDC_LIMIT_MACROS' \
        -DOSG_DETERMINE_WIN_VERSION=OFF \
        -DPKG_CONFIG_EXECUTABLE='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        -DDYNAMIC_OPENTHREADS=$(CMAKE_SHARED_BOOL) \
        -DDYNAMIC_OPENSCENEGRAPH=$(CMAKE_SHARED_BOOL) \
        -DBUILD_OSG_APPLICATIONS=OFF \
        -DOPENTHREADS_ATOMIC_USE_MUTEX=ON

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef
