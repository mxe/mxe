# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# OpenSceneGraph
PKG             := openscenegraph
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8.2
$(PKG)_CHECKSUM := f2f0a3285a022640345a81f536459f37f3f38d01
$(PKG)_SUBDIR   := OpenSceneGraph-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).zip
$(PKG)_WEBSITE  := http://www.openscenegraph.org/
$(PKG)_URL      := http://www.openscenegraph.org/downloads/stable_releases/$($(PKG)_SUBDIR)/source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc curl giflib jpeg tiff libpng jasper openexr gdal freetype zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://www.openscenegraph.org/projects/osg/browser/OpenSceneGraph/tags?order=date&desc=1' | \
    grep '<a ' | \
    $(SED) -n 's,.*>OpenSceneGraph-\([0-9][^<]*\)<.*,\1,p' | \
    grep -v '2\.8\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake .                                   \
        -DCMAKE_SYSTEM_NAME=Windows                        \
        -DCMAKE_FIND_ROOT_PATH='$(PREFIX)/$(TARGET)'       \
        -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER          \
        -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY           \
        -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY           \
        -DCMAKE_C_COMPILER='$(PREFIX)/bin/$(TARGET)-gcc'   \
        -DCMAKE_INCLUDE_PATH='$(PREFIX)/$(TARGET)/include' \
        -DCMAKE_LIB_PATH='$(PREFIX)/$(TARGET)/lib'         \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)'       \
        -DCMAKE_BUILD_TYPE=Release                         \
        -DDYNAMIC_OPENTHREADS=OFF                          \
        -DDYNAMIC_OPENSCENEGRAPH=OFF                       \
        -DBUILD_OSG_APPLICATIONS=OFF
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
