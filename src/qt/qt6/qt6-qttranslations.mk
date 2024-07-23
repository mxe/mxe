# This file is part of MXE. See LICENSE.md for licensing information.

PKG := qt6-qttranslations
$(eval $(QT6_METADATA))

$(PKG)_CHECKSUM := 9845780b5dc1b7279d57836db51aeaf2e4a1160c42be09750616f39157582ca9
$(PKG)_DEPS     := cc qt6-qtbase qt6-qttools

QT6_PREFIX   = '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
QT6_QT_CMAKE = '$(QT6_PREFIX)/$(if $(findstring mingw,$(TARGET)),bin,libexec)/qt-cmake-private' \
                   -DCMAKE_INSTALL_PREFIX='$(QT6_PREFIX)'

define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DQT_HOST_PATH='$(PREFIX)/$(BUILD)/$(MXE_QT6_ID)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
