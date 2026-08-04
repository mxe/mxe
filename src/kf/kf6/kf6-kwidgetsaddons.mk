# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-kwidgetsaddons
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 6bb6a22e40bc8cfaeda08276b771488294ad417e7802b27bdc455202afdabd7d
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase
$(PKG)_TARGETS   := $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
