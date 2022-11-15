# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := osgearth
$(PKG)_WEBSITE  := http://osgearth.org/
$(PKG)_DESCR    := Geospatial SDK for OpenSceneGraph
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.3
$(PKG)_CHECKSUM := 4b4a8ba70e707c6aae7d2fe2904b8761e9827398ddeb60633938fe486f5fa622
$(PKG)_GH_CONF  := gwaldron/osgearth/releases/latest, osgearth-
$(PKG)_DEPS     := curl cc gdal openscenegraph poco sqlite zlib geos

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake --trace-expand '$(SOURCE_DIR)' \
        -DDYNAMIC_OSGEARTH=$(CMAKE_SHARED_BOOL) \
        -DOSGEARTH_USE_PROTOBUF=OFF \
        -DWITH_EXTERNAL_TINYXML=OFF \
        -DOSGEARTH_BUILD_EXAMPLES=OFF \
        -DOSGEARTH_BUILD_TOOLS=OFF \
        -DOSGEARTH_BUILD_TESTS=OFF

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
