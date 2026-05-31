# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG             := kf6-kquickcharts
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := ae3e0784a2a2d1396cb751cc61f43a567e066d6434971246b1a18365481a1b52
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase qt6-qtdeclarative qt6-qtshadertools
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTING=OFF
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
