# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-qqc2-desktop-style
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 1805fa31355ff86c02158fd2b8d396fd88835d01db97d8700314c48ee3360986
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase qt6-qtdeclarative kf6-kconfig kf6-kirigami kf6-kiconthemes kf6-kcolorscheme
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
