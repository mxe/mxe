# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-ki18n
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 820ce5858c6db732d68da53572a0e7db8353e4372d2122debcfb0f9ff10b85db
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase qt6-qtdeclarative gettext $(BUILD)~$(PKG)
$(PKG)_DEPS_$(BUILD) := $(BUILD)~kf6-extra-cmake-modules $(BUILD)~qt6-qtbase $(BUILD)~qt6-qtdeclarative $(BUILD)~gettext
$(PKG)_TARGETS   := $(BUILD) $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
