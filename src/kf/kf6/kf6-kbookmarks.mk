# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-kbookmarks
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := d7f4048860ef00bc5d135e284dc6b1307d03199c2c13020994b17e38e3741f5c
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase kf6-kconfig kf6-kcoreaddons kf6-kwidgetsaddons
$(PKG)_TARGETS   := $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
