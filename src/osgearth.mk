# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := osgearth
$(PKG)_WEBSITE  := http://osgearth.org/
$(PKG)_DESCR    := Geospatial SDK for OpenSceneGraph
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8
$(PKG)_CHECKSUM := 5570dc5b62f6f9e28954f5cbd7946a9b35767c06b375eff1c4cc40561e7f1655
$(PKG)_GH_CONF  := gwaldron/osgearth/tags, osgearth-
$(PKG)_DEPS     := curl gcc gdal openscenegraph sqlite tinyxml2 zlib

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DWITH_EXTERNAL_TINYXML=ON \
        -DDYNAMIC_OSGEARTH=$(CMAKE_SHARED_BOOL) \
        -DBUILD_OSGEARTH_EXAMPLES=OFF

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef

