# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-purpose
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := cc7b7599d1ac7ce7ed07351a35d742fac1b7e554b208a7b1c92e859b3b4add30
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase qt6-qtdeclarative kf6-kcoreaddons kf6-ki18n kf6-kconfig kf6-kirigami kf6-knotifications kf6-kio kf6-kservice kf6-prison
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DUSE_DBUS=ON
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
