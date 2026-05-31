# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-ktexteditor
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := ec7bc094f93d514b5f675ae95c274dd24acc47769d971606d8708cc88f811341
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase qt6-qtdeclarative qt6-qtspeech kf6-karchive kf6-kconfig kf6-kguiaddons kf6-ki18n kf6-kio kf6-kparts kf6-sonnet kf6-syntax-highlighting kf6-kcolorscheme
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DENABLE_KAUTH=OFF
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
