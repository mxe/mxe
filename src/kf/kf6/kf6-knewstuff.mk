# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-knewstuff
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 94ef39077ba53a72f4e555b6f94a2762cba79730619cb80a31c5435642ebe1aa
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase qt6-qtdeclarative kf6-karchive kf6-kconfig kf6-kcoreaddons kf6-ki18n kf6-kpackage kf6-kwidgetsaddons kf6-attica kf6-kirigami kf6-syndication
$(PKG)_TARGETS   := $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
