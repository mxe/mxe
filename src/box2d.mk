# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := box2d
$(PKG)_WEBSITE  := https://www.box2d.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.2
$(PKG)_SUBDIR   := box2d-$($(PKG)_VERSION)
$(PKG)_CHECKSUM := 85b9b104d256c985e6e244b4227d447897fac429071cc114e5cc819dae848852
$(PKG)_GH_CONF  := erincatto/Box2D/tags, v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DBOX2D_BUILD_TESTBED=OFF \
        -DBOX2D_BUILD_UNIT_TESTS=OFF \
        '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef
