# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-kconfigwidgets
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := f795386fb06b8922325075a8fa9f817c3d25e04bbfdcf60b13ad714c7c54e987
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase kf6-kcoreaddons kf6-kcodecs kf6-kconfig kf6-kguiaddons kf6-ki18n kf6-kwidgetsaddons kf6-kcolorscheme
$(PKG)_TARGETS   := $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
