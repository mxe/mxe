# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG             := kf6-extra-cmake-modules
$(PKG)_DEPS     := kf6-conf
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_CHECKSUM := f4e10d9d45aafb5273e996196040f4e420f0bc4071c208282aae94d9ad8e1743

$(eval $(call KF6_METADATA))

define $(PKG)_BUILD
    # ECM needs to be installed, but it's just CMake scripts.
    # We use the standard KF6_CMAKE wrapper.
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
