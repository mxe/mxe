# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-kxmlgui
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := e40b86ebb9f1be00255cd4835ab0b0ac8650c47d0eb17a47d9df7d4b5658df58
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase kf6-kcoreaddons kf6-kitemviews kf6-kconfig kf6-kconfigwidgets kf6-kguiaddons kf6-ki18n kf6-kiconthemes kf6-kwidgetsaddons
$(PKG)_TARGETS   := $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
