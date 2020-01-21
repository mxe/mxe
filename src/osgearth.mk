# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := osgearth
$(PKG)_WEBSITE  := http://osgearth.org/
$(PKG)_DESCR    := Geospatial SDK for OpenSceneGraph
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.10
$(PKG)_CHECKSUM := 986ad26b8e340a40ac6404137aa61f80a030030fa3e8cf5fbdf183c697f2556e
$(PKG)_GH_CONF  := gwaldron/osgearth/releases/latest, osgearth-
$(PKG)_DEPS     := curl cc gdal openscenegraph poco sqlite zlib

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DDYNAMIC_OSGEARTH=$(CMAKE_SHARED_BOOL) \
        -DOSGEARTH_USE_PROTOBUF=OFF \
        -DWITH_EXTERNAL_TINYXML=OFF \
        -DBUILD_OSGEARTH_EXAMPLES=OFF \
        -DBUILD_APPLICATIONS=OFF \
        -DBUILD_TESTS=OFF

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
