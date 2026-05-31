# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-kconfig
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 8bb5aa918d8e60ec140a33db3c329414d2319dc97a1644b368da5576125c92b5
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase qt6-qtdeclarative qt6-qttools $(BUILD)~$(PKG)
$(PKG)_DEPS_$(BUILD) := $(BUILD)~kf6-extra-cmake-modules $(BUILD)~qt6-qtbase $(BUILD)~qt6-qtdeclarative $(BUILD)~qt6-qttools
$(PKG)_TARGETS   := $(BUILD) $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
