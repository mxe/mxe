# This file is part of MXE. See LICENSE.md for licensing information.

include src/qt/qt6/qt6-conf.mk

PKG := qt6-qtvirtualkeyboard
$(eval $(QT6_METADATA))

$(PKG)_CHECKSUM := d88a4b1713a313e3ac06c32837b5d00724d1dcf7b44c2594f1029f7c74a8e686
$(PKG)_DEPS     := cc qt6-conf qt6-qtbase qt6-qtdeclarative qt6-qtsvg

QT6_PREFIX   = '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
QT6_QT_CMAKE = '$(QT6_PREFIX)/$(if $(findstring mingw,$(TARGET)),bin,libexec)/qt-cmake-private' \
                   -DCMAKE_INSTALL_PREFIX='$(QT6_PREFIX)'

define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
