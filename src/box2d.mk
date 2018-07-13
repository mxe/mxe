# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := box2d
$(PKG)_WEBSITE  := https://www.box2d.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.1
$(PKG)_CHECKSUM := 75d62738b13d2836cd56647581b6e574d4005a6e077ddefa5d727d445d649752
$(PKG)_GH_CONF  := erincatto/Box2D/tags, v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
        -DBOX2D_INSTALL=ON \
        -DBOX2D_BUILD_EXAMPLES=OFF \
        -DBOX2D_BUILD_STATIC=$(CMAKE_STATIC_BOOL) \
        -DBOX2D_BUILD_SHARED=$(CMAKE_SHARED_BOOL) \
        '$(SOURCE_DIR)/Box2D'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef
