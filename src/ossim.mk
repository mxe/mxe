# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ossim
$(PKG)_WEBSITE  := https://trac.osgeo.org/ossim
$(PKG)_DESCR    := OSSIM
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1af3774
$(PKG)_CHECKSUM := 159bc40a90c79065cfe3f144f5afe2fe7944721d15dc96eefc4163d4629f9230
# releases have unpredictable names and are based on master branch
$(PKG)_GH_CONF  := ossimlabs/ossim/branches/master
$(PKG)_DEPS     := cc freetype geos hdf5 jpeg libgeotiff libpng openthreads proj \
  tiff zlib jsoncpp

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMAKE_VERBOSE_MAKEFILE=TRUE \
        -DBUILD_OSSIM_FREETYPE_SUPPORT=TRUE \
        -DBUILD_OSSIM_CURL_APPS=FALSE \
        -DBUILD_OSSIM_TESTS=FALSE \
        -DBUILD_OSSIM_APPS=FALSE

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef
