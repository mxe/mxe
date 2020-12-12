# This file is part of MXE. See LICENSE.md for licensing information.

PKG := qt6-qttools
$(eval $(QT6_METADATA))

$(PKG)_CHECKSUM := b6dc559db447bf394d09dfb238d5c09108f834139a183888179e855c6566bfae
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc qt6-qtbase #qt6-qtdeclarative
$(PKG)_DEPS_$(BUILD) := qt6-qtbase

define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DQT_BUILD_TOOLS_WHEN_CROSSCOMPILING=ON
    cmake --build '$(BUILD_DIR)' -j '$(JOBS)'
    cmake --install '$(BUILD_DIR)'

    # test QUiLoader
    $(QT6_QT_CMAKE) -S '$(PWD)/src/cmake/test' -B '$(BUILD_DIR).test-cmake' \
        -DQT_MAJOR=6 \
        -DPKG=qttools \
        -DPKG_VERSION=$($(PKG)_VERSION)
    $(QT6_QT_CMAKE) -j '$(JOBS)' --build '$(BUILD_DIR).test-cmake'
    $(QT6_QT_CMAKE) --install '$(BUILD_DIR).test-cmake'
endef

define $(PKG)_BUILD_$(BUILD)
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    cmake --build '$(BUILD_DIR)' -j '$(JOBS)'
    cmake --install '$(BUILD_DIR)'
endef
