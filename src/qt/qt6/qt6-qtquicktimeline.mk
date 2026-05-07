# This file is part of MXE. See LICENSE.md for licensing information.
include src/qt/qt6/qt6-conf.mk
PKG := qt6-qtquicktimeline
$(eval $(QT6_METADATA))
$(PKG)_CHECKSUM := 06dbe1cc541431fa321023992ca4ccf83c76b25d07bbf516e0af887a38f32cd6
$(PKG)_URL      := https://download.qt.io/official_releases/qt/6.11/6.11.0/submodules/qtquicktimeline-everywhere-src-6.11.0.tar.xz
$(PKG)_DEPS     := cc qt6-conf qt6-qtbase qt6-qtdeclarative
QT6_PREFIX   = '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
