# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtwebkit
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.212
$(PKG)_CHECKSUM := 283b907ea324a2c734e3983c73fc27dbd8b33e2383c583de41842ee84d648a3e
$(PKG)_SUBDIR   := qtwebkit-everywhere-src-$($(PKG)_VERSION)
$(PKG)_FILE     := qtwebkit-everywhere-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.qt.io/snapshots/ci/qtwebkit/$($(PKG)_VERSION)/latest/src/submodules/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libxslt qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD_SHARED

cd '$(BUILD_DIR)' && $(TARGET)-cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DPORT=Qt \
    -DCMAKE_SYSTEM_PROCESSOR=x86_64 \
    -DENABLE_INSPECTOR_UI=OFF \
    -DENABLE_DEVICE_ORIENTATION=OFF \
    -DUSE_QT_MULTIMEDIA=OFF \
    -DENABLE_VIDEO=OFF \
    -DENABLE_QT_WEBCHANNEL=OFF \
    -DENABLE_GEOLOCATION=OFF \
    -DCMAKE_INSTALL_PREFIX=$(PREFIX)/$(TARGET)/qt5 \
    '$(SOURCE_DIR)'

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
