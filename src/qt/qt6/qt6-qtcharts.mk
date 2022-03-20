# This file is part of MXE. See LICENSE.md for licensing information.

PKG := qt6-qtcharts
$(eval $(QT6_METADATA))

$(PKG)_CHECKSUM := 3c2e6267ef0fb5345c7737e3a12e09ce9ec09117792e78af9a8617f828b2249a
$(PKG)_DEPS     := cc qt6-qtbase

QT6_PREFIX   = '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
QT6_QT_CMAKE = '$(QT6_PREFIX)/bin/qt-cmake-private' \
                   -DCMAKE_INSTALL_PREFIX='$(QT6_PREFIX)'

define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
