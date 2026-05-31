# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-kcmutils
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 6d0810649b71528124cdf9dbdeb8b3c6c6d31d787325ca3e4a20c536ecbdf2d9
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase qt6-qtdeclarative kf6-kconfig kf6-kcoreaddons kf6-ki18n kf6-kio kf6-kitemviews kf6-kxmlgui kf6-kwidgetsaddons kf6-kdeclarative kf6-kirigami
$(PKG)_TARGETS   := $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
