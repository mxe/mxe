# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-kparts
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 049c2cf048b4cbbffe0bea9357bd9ab53b8be672ba509b2bb058f764d21b3f5b
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase kf6-kconfig kf6-kcoreaddons kf6-ki18n kf6-kio kf6-kjobwidgets kf6-kservice kf6-kwidgetsaddons kf6-kxmlgui
$(PKG)_TARGETS   := $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
