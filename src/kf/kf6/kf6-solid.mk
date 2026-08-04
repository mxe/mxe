# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-solid
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 47fa84db565372584c6ecb03f71a6085f706a1c031ea4f2ffc35808f09a19b3d
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase qt6-qtdeclarative
$(PKG)_TARGETS   := $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
