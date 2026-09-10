# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := kde-libkmahjongg
$(PKG)_WEBSITE  := https://apps.kde.org/it/kmahjongg/
$(PKG)_DESCR    := KMahjongg library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 26.04.3
$(PKG)_CHECKSUM := 1914c780160d8913dd649fdd1b0760b445523c09b572f45ce99c08196e29c7e8
$(PKG)_SUBDIR   := libkmahjongg-$($(PKG)_VERSION)
$(PKG)_FILE     := libkmahjongg-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.kde.org/stable/release-service/$($(PKG)_VERSION)/src/$($(PKG)_FILE)
$(PKG)_DEPS     := cc qt6-qtbase qt6-qtsvg kf6-kconfig kf6-kconfigwidgets \
                   kf6-kcoreaddons kf6-kwidgetsaddons kf6-ki18n

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.kde.org/stable/release-service/' | \
    grep -o 'href="[0-9]*\.[0-9]*\.[0-9]*' | \
    $(SED) 's/href="//' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DBUILD_TESTING=OFF \
        -DBUILD_DOC=OFF
    
    cd '$(BUILD_DIR)' && $(TARGET)-cmake --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && $(TARGET)-cmake --install .
endef
