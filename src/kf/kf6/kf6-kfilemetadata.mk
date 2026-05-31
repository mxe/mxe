# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-kfilemetadata
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := f75942b9a3d1be0b0910cd50a22c3c432ededdc506858c8d5511ddf5498051f2
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase qt6-qtdeclarative kf6-karchive kf6-kcoreaddons kf6-kconfig kf6-ki18n kf6-kcodecs taglib exiv2 ffmpeg
$(PKG)_TARGETS   := $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
