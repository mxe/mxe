# This file is part of MXE. See LICENSE.md for licensing information.

PKG := qt6-qtserialport
$(eval $(QT6_METADATA))

$(PKG)_CHECKSUM := 8fdbfbb2aeee0e6400c90406927a784d3790bb0dfa7e5d7b9da7b2ded52bb744
$(PKG)_DEPS     := cc qt6-qtbase

QT6_PREFIX   = '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
QT6_QT_CMAKE = '$(QT6_PREFIX)/bin/qt-cmake-private' \
                   -DCMAKE_INSTALL_PREFIX='$(QT6_PREFIX)'

define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
