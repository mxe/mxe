# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ossim
$(PKG)_WEBSITE  := https://trac.osgeo.org/ossim
$(PKG)_DESCR    := OSSIM
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 43a071a
$(PKG)_CHECKSUM := 1796994c8586e62ef799724969e3bef57178194fafe056db3de41dd6ee0dc931
# releases have unpredictable names and are based on master branch
$(PKG)_GH_CONF  := ossimlabs/ossim/master
$(PKG)_DEPS     := cc freetype geos hdf5 jpeg libgeotiff libpng openthreads proj tiff zlib

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMAKE_VERBOSE_MAKEFILE=TRUE \
        -DBUILD_OSSIM_FREETYPE_SUPPORT=TRUE \
        -DBUILD_OSSIM_CURL_APPS=FALSE \
        -DBUILD_OSSIM_TESTS=FALSE \
        -DBUILD_OSSIM_APPS=FALSE \
        -DCMAKE_CXX_FLAGS='-DGEOS_INLINE=1'

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef
