# This file is part of MXE.
# See index.html for further information.

PKG             := openscenegraph
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 13c7e39f6d62047ad944d8d28a0f0eb60384ce33
$(PKG)_SUBDIR   := OpenSceneGraph-$($(PKG)_VERSION)
$(PKG)_FILE     := OpenSceneGraph-$($(PKG)_VERSION).zip
$(PKG)_URL      := http://www.openscenegraph.org/downloads/stable_releases/OpenSceneGraph-$($(PKG)_VERSION)/source/$($(PKG)_FILE)
$(PKG)_URL_2    := http://www.openscenegraph.org/downloads/developer_releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc curl ffmpeg freetype gdal giflib jasper jpeg libpng openexr tiff xine-lib zlib dcmtk qt

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.openscenegraph.org/projects/osg/browser/OpenSceneGraph/tags?order=date&desc=1' | \
    grep '<a ' | \
    $(SED) -n 's,.*>OpenSceneGraph-\([0-9]*\.[0-9]*[02468]\.[^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_CXX_FLAGS=-D__STDC_CONSTANT_MACROS \
        -DCMAKE_HAVE_PTHREAD_H=OFF \
        -DDYNAMIC_OPENTHREADS=OFF \
        -DDYNAMIC_OPENSCENEGRAPH=OFF \
        -DBUILD_OSG_APPLICATIONS=OFF \
        -D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS_EXITCODE=1
    $(MAKE) -C '$(1)' -j '$(JOBS)' install VERBOSE=1
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =
$(PKG)_BUILD_i686-w64-mingw32 =
