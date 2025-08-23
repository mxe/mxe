# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ninja
$(PKG)_WEBSITE  := https://ninja-build.org
$(PKG)_DESCR    := A small build system with a focus on speed
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.13.1
$(PKG)_CHECKSUM := f0055ad0369bf2e372955ba55128d000cfcc21777057806015b45e4accbebf23
$(PKG)_GH_CONF  := ninja-build/ninja/tags,v
$(PKG)_TARGETS  := $(BUILD)

define $(PKG)_BUILD_$(BUILD)
    '$(TARGET)-cmake' -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)' \
        -DBUILD_TESTING=OFF
    '$(TARGET)-cmake' --build '$(BUILD_DIR)' -j '$(JOBS)'
    '$(TARGET)-cmake' --install '$(BUILD_DIR)'
endef
