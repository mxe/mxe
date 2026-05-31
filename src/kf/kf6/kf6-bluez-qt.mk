# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-bluez-qt
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := ebeb301eaeb6ec6729b27969556839165ba582ebe242b42cde71c8faa80d63df
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase
$(PKG)_TARGETS   := $(MXE_TARGETS)
define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef

$(PKG)_IGNORE    := explicitly unsupported on Windows by KDE (metainfo.yaml platform check)
$(PKG)_BUILD     :=
