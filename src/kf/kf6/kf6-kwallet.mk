# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-kwallet
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 2321f8591f1f225d3d7253fae9ee61d0789db231b3eeae6a5f8a14c013531389
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase
define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef

$(PKG)_IGNORE    := requires Qca-qt6 and Gpgmepp which are not ported to Qt6 in MXE
$(PKG)_BUILD     :=
