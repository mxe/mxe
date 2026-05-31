# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-kiconthemes
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := ed6c0c0bfed517dd5b6462d9b1c84ebe7bc99c7a75214921b5978f086df8653d
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase qt6-qtsvg kf6-karchive kf6-ki18n kf6-kcolorscheme kf6-kwidgetsaddons kf6-breeze-icons
$(PKG)_TARGETS   := $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
