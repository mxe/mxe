# This file is part of MXE. See LICENSE.md for licensing information.

PKG := qt6-qtimageformats
$(eval $(QT6_METADATA))

$(PKG)_CHECKSUM := 9150bce23e6002e3c08229222142374b24db91132e1ff5c05bce028fc8fc0af6
$(PKG)_DEPS     := cc qt6-qtbase jasper libmng libwebp tiff

QT6_PREFIX   = '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
QT6_QT_CMAKE = '$(QT6_PREFIX)/bin/qt-cmake-private' \
                   -DCMAKE_INSTALL_PREFIX='$(QT6_PREFIX)'

define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
