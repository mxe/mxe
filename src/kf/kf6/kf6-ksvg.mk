# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-ksvg
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := f3a7412e227d13b1cafec91c1b58dd3f86980abefc08b2535b46bef362b4c07e
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase qt6-qtdeclarative qt6-qtsvg kf6-karchive kf6-kconfig kf6-kcolorscheme kf6-kcoreaddons kf6-kguiaddons kf6-kirigami
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DBUILD_TESTING=OFF
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
