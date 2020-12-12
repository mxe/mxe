# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ninja
$(PKG)_WEBSITE  := https://ninja-build.org
$(PKG)_DESCR    := A small build system with a focus on speed
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.10.2
$(PKG)_CHECKSUM := ce35865411f0490368a8fc383f29071de6690cbadc27704734978221f25e2bed
$(PKG)_GH_CONF  := ninja-build/ninja/tags,v
$(PKG)_DEPS     := cmake
$(PKG)_TARGETS  := $(BUILD)

define $(PKG)_BUILD
    cmake -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)' \
        -DBUILD_TESTING=OFF
    cmake --build '$(BUILD_DIR)' -j '$(JOBS)'
    cmake --install '$(BUILD_DIR)'
endef
