# This file is part of MXE. See LICENSE.md for licensing information.

PKG := qt6-qtcharts
$(eval $(QT6_METADATA))

$(PKG)_CHECKSUM := 52581b5e2bbf7eb65a7f22f8698ddc0551f2c3af29aa87784e0b22ed991ce003
$(PKG)_DEPS     := cc qt6-qtbase

QT6_PREFIX   = '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
QT6_QT_CMAKE = '$(QT6_PREFIX)/bin/qt-cmake-private' \
                   -DCMAKE_INSTALL_PREFIX='$(QT6_PREFIX)'

define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
