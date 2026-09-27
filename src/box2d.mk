# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := box2d
$(PKG)_WEBSITE  := https://www.box2d.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.1
$(PKG)_CHECKSUM := fb6ef914b50f4312d7d921a600eabc12318bb3c55a0b8c0b90608fa4488ef2e4
$(PKG)_GH_CONF  := erincatto/box2d/tags, v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
        -DBOX2D_INSTALL=ON \
        -DBOX2D_BUILD_EXAMPLES=OFF \
        -DBOX2D_DOCS=OFF \
        -DBOX2D_UNIT_TESTS=OFF \
        -DBOX2D_SAMPLES=OFF \
        -DBOX2D_BENCHMARKS=OFF \
        -DBOX2D_BUILD_STATIC=$(CMAKE_STATIC_BOOL) \
        -DBOX2D_BUILD_SHARED=$(CMAKE_SHARED_BOOL) \
        '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef
