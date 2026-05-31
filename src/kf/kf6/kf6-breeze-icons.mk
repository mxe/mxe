# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-breeze-icons
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 4e123fac511dfab2b7c505857849a5cecfac2ce6194e3230c51ceec31676b06e
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase $(BUILD)~$(PKG)
$(PKG)_DEPS_$(BUILD) := $(BUILD)~kf6-extra-cmake-modules $(BUILD)~qt6-qtbase
$(PKG)_TARGETS   := $(BUILD) $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD_$(BUILD)
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DINSTALL_HOST_TOOLS=ON \
        -DBINARY_ICONS_RESOURCE=OFF \
        -DSKIP_INSTALL_ICONS=ON
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DBINARY_ICONS_RESOURCE=ON \
        -DSKIP_INSTALL_ICONS=OFF
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
