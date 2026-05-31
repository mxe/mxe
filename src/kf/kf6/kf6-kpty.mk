# This file is part of MXE. See LICENSE.md for licensing information.

include src/kf/kf6/kf6-conf.mk

PKG             := kf6-kpty
$(eval $(call KF6_METADATA))

$(PKG)_CHECKSUM  := 7613c26cfaa7465a2fe28a22762ceb38266414e7f4a94a127c09dc0628625553
$(PKG)_DEPS      := kf6-conf kf6-extra-cmake-modules qt6-qtbase
define $(PKG)_BUILD
    $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef

$(PKG)_IGNORE    := explicitly unsupported on Windows (requires POSIX/UNIX PTYs)
$(PKG)_BUILD     :=
