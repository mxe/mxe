# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-syndication
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 24db750155b69e3f858997cad0655a2f230f85d587c1063166113bc7690fd7b8
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase kf6-kcodecs
$(PKG)_TARGETS   := $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
