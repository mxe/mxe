# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-prison
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 0414ddc310bca5eecfc1a6f9d4463b8a6d81894db4128ac43b4f8c1e14b73b5b
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase qt6-qtdeclarative qt6-qtmultimedia libqrencode
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DWITH_DMTX=OFF \
        -DWITH_ZXING=OFF
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
