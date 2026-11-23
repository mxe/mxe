# This file is part of MXE. See LICENSE.md for licensing information.

include src/qt/qt6/qt6-conf.mk

PKG := qt6-qtcoap
$(eval $(QT6_METADATA))

$(PKG)_SUBDIR   := qtcoap-$($(PKG)_VERSION)
$(PKG)_FILE     := qtcoap-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/qt/qtcoap/archive/refs/tags/v$($(PKG)_VERSION).tar.gz
$(PKG)_CHECKSUM := e947c0477220348084df3f46e5f9c5f67fafe50fc92aa4b9033e27b7c6ccb0d2
$(PKG)_DEPS     := cc qt6-conf qt6-qtbase

QT6_PREFIX   = '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
QT6_QT_CMAKE = '$(QT6_PREFIX)/$(if $(findstring mingw,$(TARGET)),bin,libexec)/qt-cmake-private' \
                   -DCMAKE_INSTALL_PREFIX='$(QT6_PREFIX)'

define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
