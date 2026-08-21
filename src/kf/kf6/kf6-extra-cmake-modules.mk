# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-extra-cmake-modules
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := a32e24b267e8528d0253bc8df18bdc00e676560a43b796533e1b1406f4eef4db
$(PKG)_DEPS     := kf6-conf
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_IGNORE   := 

define $(PKG)_BUILD_$(BUILD)
    '$(TARGET)-cmake' -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -G Ninja \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)' \
        -DBUILD_TESTING=OFF \
        -DKDE_INSTALL_USE_QT_SYS_PATHS=ON
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef

define $(PKG)_BUILD
    # ECM needs to be installed, but it's just CMake scripts.
    # We use the standard KF6_CMAKE wrapper.
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
