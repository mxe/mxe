# This file is part of MXE. See LICENSE.md for licensing information.

include src/qt/qt6/qt6-conf.mk

PKG := qt6-qtcharts
$(eval $(QT6_METADATA))

$(PKG)_CHECKSUM := ac409bd4085772f7f091438cce05213b2a88a6edbab16e3dd7a96122386d94b5
$(PKG)_DEPS     := cc qt6-conf qt6-qtbase qt6-qtdeclarative

QT6_PREFIX   = '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
QT6_QT_CMAKE = '$(QT6_PREFIX)/$(if $(findstring mingw,$(TARGET)),bin,libexec)/qt-cmake-private' \
                   -DCMAKE_INSTALL_PREFIX='$(QT6_PREFIX)'

define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
