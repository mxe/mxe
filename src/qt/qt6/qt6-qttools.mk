# This file is part of MXE. See LICENSE.md for licensing information.

include src/qt/qt6/qt6-conf.mk

PKG := qt6-qttools
$(eval $(QT6_METADATA))

$(PKG)_CHECKSUM := 9e20562c6b04c21fbdb4ed89e59226169ffeaafaab8f45f7d81ea49b0e4b0933
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) := qt6-conf qt6-qtbase
$(PKG)_DEPS     := cc $($(PKG)_DEPS_$(BUILD)) qt6-qtdeclarative $(BUILD)~$(PKG)

define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DQT_BUILD_TOOLS_WHEN_CROSSCOMPILING=ON
    # not built for some reason. make dummy so install won't fail
    touch '$(BUILD_DIR)/bin/qhelpgenerator.exe'
    cmake --build '$(BUILD_DIR)' -j '$(JOBS)'
    cmake --install '$(BUILD_DIR)'

    # test QUiLoader
    $(QT6_QT_CMAKE) -S '$(PWD)/src/cmake/test' -B '$(BUILD_DIR).test-cmake' \
        -DQT_MAJOR=6 \
        -DPKG=qttools \
        -DPKG_VERSION=$($(PKG)_VERSION)
    '$(TARGET)-cmake' --build '$(BUILD_DIR).test-cmake' -j '$(JOBS)'
    '$(TARGET)-cmake' --install '$(BUILD_DIR).test-cmake'
endef

define $(PKG)_BUILD_$(BUILD)
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DFEATURE_linguist=ON \
        -DFEATURE_designer=OFF
    cmake --build '$(BUILD_DIR)' -j '$(JOBS)'
    cmake --install '$(BUILD_DIR)'
endef
