# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-kxmlgui
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 4383855cea5a7f9a269c72dda15490b8d70c1d23d17950963937332fc5d6b7a0
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase kf6-kcoreaddons kf6-kitemviews kf6-kconfig kf6-kconfigwidgets kf6-kguiaddons kf6-ki18n kf6-kiconthemes
$(PKG)_TARGETS   := $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
