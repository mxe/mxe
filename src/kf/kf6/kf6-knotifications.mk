# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-knotifications
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := e5d3b284ccc907f190d3ab10995a0ae7fa0f505088acc69edc7adfcc6a8140d6
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase qt6-qtdeclarative kf6-kconfig canberra
$(PKG)_TARGETS   := $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DWITH_SNORETOAST=OFF
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
