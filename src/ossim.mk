# This file is part of MXE.
# See index.html for further information.

PKG             := ossim
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.18
$(PKG)_CHECKSUM := 2dd070c2174dab08c04092345e5165ec45dcd5b63be88771c942843a250518ae
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.osgeo.org/ossim/source/$($(PKG)_SUBDIR)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc freetype geos jpeg libpng openscenegraph proj tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://download.osgeo.org/ossim/source/latest/' | \
    $(SED) -n 's,.*ossim-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_MODULE_PATH='$(1)/ossim_package_support/cmake/CMakeModules' \
        -DCMAKE_CXX_FLAGS='-DGEOS_INLINE=1' \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DBUILD_OSSIM_FREETYPE_SUPPORT=ON \
        '$(1)/ossim'
    $(MAKE) -C '$(1).build/src/ossim' -j '$(JOBS)'
    $(MAKE) -C '$(1).build/src/ossim' -j 1 install
endef
