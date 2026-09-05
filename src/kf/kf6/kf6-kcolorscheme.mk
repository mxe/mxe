# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-kcolorscheme
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 129c98fd9ba3428cafbd7263557a9ea47c0d4f157b8a5f56b209a95dc9815e6a
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase kf6-kconfig kf6-kguiaddons kf6-ki18n
$(PKG)_TARGETS   := $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
