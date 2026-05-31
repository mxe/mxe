# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-kpackage
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 313cda4a335ecdb67bb8e2fcc15bdeb5970db17d5597282ca655bf97a98abab5
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase kf6-karchive kf6-ki18n kf6-kcoreaddons kf6-kdoctools $(BUILD)~$(PKG)
$(PKG)_DEPS_$(BUILD) := $(BUILD)~kf6-extra-cmake-modules $(BUILD)~qt6-qtbase $(BUILD)~kf6-karchive $(BUILD)~kf6-ki18n $(BUILD)~kf6-kcoreaddons $(BUILD)~kf6-kdoctools
$(PKG)_TARGETS   := $(BUILD) $(MXE_TARGETS)
$(PKG)_IGNORE    := _$(BUILD)

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
