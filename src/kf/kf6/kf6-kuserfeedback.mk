# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-kuserfeedback
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 6cc18dca65a24af2ac262cb9c8761991701c8081a7133487b4ec936003f3f864
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase qt6-qtcharts qt6-qtdeclarative qt6-qtsvg
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DENABLE_PHP=OFF \
        -DENABLE_PHP_UNIT=OFF \
        -DENABLE_DOCS=OFF \
        -DENABLE_CONSOLE=OFF \
        -DBUILD_TESTING=OFF
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
