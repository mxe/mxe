# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-kded
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 4265d1162cbd7febf16d103bf1bd9fab858fa3f54f52797ed0938436bee347af
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase
$(PKG)_TARGETS   := $(MXE_TARGETS)
define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef

$(PKG)_IGNORE    := explicitly unsupported on Windows by KDE (metainfo.yaml platform check)
$(PKG)_BUILD     :=
