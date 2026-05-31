# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-kpeople
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := bd1092cd9900d0ee3b3d08d0971e669a82d1a11c9bec6e2322d713b59191b873
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase qt6-qtdeclarative kf6-kcoreaddons kf6-kwidgetsaddons kf6-ki18n kf6-kitemviews kf6-kcontacts
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
