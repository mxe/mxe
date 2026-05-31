# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-networkmanager-qt
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := a5cfed06af6156161f7fee56efe1521a6e9e26119327069f1799986f90b432e5
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase
define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef

$(PKG)_IGNORE    := explicitly unsupported on Windows by KDE (metainfo.yaml platform check)
$(PKG)_BUILD     :=
