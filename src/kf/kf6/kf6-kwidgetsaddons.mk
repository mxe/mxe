# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-kwidgetsaddons
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 65044882e30b305fe9fb20331a354cd811ca9d80b5c7f9fa722639f3334fe630
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase
$(PKG)_TARGETS   := $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
