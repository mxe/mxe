# This file is part of MXE. See LICENSE.md for licensing information.

include src/qt/qt6/qt6-conf.mk

PKG := qt6-qtmultimedia
$(eval $(QT6_METADATA))

$(PKG)_CHECKSUM := c086d43a026e6090971fd7a697ef8370c5c455115240609cd08d5e2f840dbaaf
$(PKG)_DEPS     := cc qt6-conf qt6-qtbase qt6-qtshadertools ffmpeg

QT6_PREFIX   = '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
QT6_QT_CMAKE = '$(QT6_PREFIX)/bin/qt-cmake-private' \
                   -DCMAKE_INSTALL_PREFIX='$(QT6_PREFIX)'

define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
	 -DFEATURE_gstreamer=OFF
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
