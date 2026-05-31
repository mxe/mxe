# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-knotifyconfig
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 062e22f48a1da485d42ef56b37db1fc502f5f9305871483627d218f357560a28
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase qt6-qtmultimedia kf6-kcompletion kf6-kconfig kf6-ki18n kf6-kio
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DUSE_DBUS=ON
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
