# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-baloo
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 702f5b868aaef48153c6c3828111b3b335403079491a8f37043ebd89c6995b30
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase
$(PKG)_TARGETS   := $(MXE_TARGETS)
define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef

$(PKG)_IGNORE    := explicitly unsupported on Windows by KDE (metainfo.yaml platform check)
$(PKG)_BUILD     :=
