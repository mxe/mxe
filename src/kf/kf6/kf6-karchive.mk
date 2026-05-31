# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-karchive
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := a7fdf6d0b8db88d60aa52bcc87d8e00d95391a1ad39a4b2a8e9f3027b8ff4035
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase zlib bzip2 xz
$(PKG)_DEPS_$(BUILD) := $(BUILD)~kf6-extra-cmake-modules $(BUILD)~qt6-qtbase $(BUILD)~zlib
$(PKG)_TARGETS   := $(BUILD) $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
