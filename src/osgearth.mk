# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := osgearth
$(PKG)_WEBSITE  := http://osgearth.org/
$(PKG)_DESCR    := Geospatial SDK for OpenSceneGraph
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.8.1
$(PKG)_CHECKSUM := 2d195ed9ec16b38373a8d2700baec2208cc18fa9a1b2ad46cd453ae8ef5cf5ed
$(PKG)_GH_CONF  := gwaldron/osgearth/releases/latest, osgearth-
$(PKG)_DEPS     := curl cc gdal openscenegraph sqlite zlib

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DOSGEARTH_BUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DOSGEARTH_BUILD_{DOCS,EXAMPLES,TESTS,TOOLS}=OFF \
        -DCMAKE_CXX_FLAGS='-DWIN32 -DWINVER=0x0605 -D_WIN32_WINNT=0x0605 $(if $(BUILD_STATIC), -DOSG_LIBRARY_STATIC,)'

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
