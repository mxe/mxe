# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG              := kf6-ktextwidgets
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 6511f9909f90fac951e2873a44dd451b8ac71d38085a62c65a6fb5028e62d84d
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase kf6-kcompletion kf6-kconfig kf6-ki18n kf6-kwidgetsaddons kf6-sonnet
$(PKG)_TARGETS   := $(MXE_TARGETS)
$(PKG)_IGNORE    := 

define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DWITH_TEXT_TO_SPEECH=OFF
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
