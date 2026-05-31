# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-kcoreaddons
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 92fdbfab68e52d9eacf44a992f01cb364d6395c24441e2fd47dd48a23b3281f6
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase qt6-qtdeclarative qt6-qttools $(BUILD)~$(PKG)
$(PKG)_DEPS_$(BUILD) := $(BUILD)~kf6-extra-cmake-modules $(BUILD)~qt6-qtbase $(BUILD)~qt6-qtdeclarative $(BUILD)~qt6-qttools
$(PKG)_TARGETS   := $(BUILD) $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
