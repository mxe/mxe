# This file is part of MXE. See LICENSE.md for licensing information.

include src/qt/qt6/qt6-conf.mk

PKG := qt6-qtmultimedia
$(eval $(QT6_METADATA))

$(PKG)_CHECKSUM := be00f830d2b14c9a12f3b6812ba3a23fdaaceb2dd9c1c6394c329c8bf6e53ab2
$(PKG)_DEPS     := cc qt6-conf qt6-qtbase qt6-qtshadertools ffmpeg

QT6_PREFIX   = '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
QT6_QT_CMAKE = '$(QT6_PREFIX)/$(if $(findstring mingw,$(TARGET)),bin,libexec)/qt-cmake-private' \
                   -DCMAKE_INSTALL_PREFIX='$(QT6_PREFIX)'

define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
	 -DFEATURE_gstreamer=OFF
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
