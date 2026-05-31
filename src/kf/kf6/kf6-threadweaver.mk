# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-threadweaver
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := ad32daeafac62077590885f3abc4bcac1abbc6faeb34c20b32f6040648f7de1b
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase
$(PKG)_TARGETS   := $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
