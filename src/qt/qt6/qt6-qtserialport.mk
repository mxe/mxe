# This file is part of MXE. See LICENSE.md for licensing information.

PKG := qt6-qtserialport
$(eval $(QT6_METADATA))

$(PKG)_CHECKSUM := ce610c0edbdf22332acb445053e4f91d5f8579c21c07e5cd680b0cf770a0e2cf
$(PKG)_DEPS     := cc qt6-qtbase

QT6_PREFIX   = '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
QT6_QT_CMAKE = '$(QT6_PREFIX)/bin/qt-cmake-private' \
                   -DCMAKE_INSTALL_PREFIX='$(QT6_PREFIX)'

define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
