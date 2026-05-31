# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-kio
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 567f64db9766986b5535d884a5db30203685c33e67f56892bceff30e1bd5cc8a
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase qt6-qtdeclarative kf6-karchive kf6-kconfig kf6-kcoreaddons kf6-kcrash kf6-kdbusaddons kf6-ki18n kf6-kservice kf6-solid kf6-kbookmarks kf6-kcolorscheme kf6-kcompletion kf6-kguiaddons kf6-kiconthemes kf6-kitemviews kf6-kjobwidgets kf6-kwidgetsaddons kf6-kwindowsystem
$(PKG)_TARGETS   := $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
