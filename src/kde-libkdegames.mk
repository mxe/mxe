# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := kde-libkdegames
$(PKG)_WEBSITE  := https://invent.kde.org/games/libkdegames
$(PKG)_DESCR    := KDE Games Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 26.04.1
$(PKG)_CHECKSUM := 31c83b61851eb7879a4b96c961cdeb32f4e131ab798122c18db59ed673f0af14
$(PKG)_SUBDIR   := libkdegames-$($(PKG)_VERSION)
$(PKG)_FILE     := libkdegames-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.kde.org/stable/release-service/$($(PKG)_VERSION)/src/$($(PKG)_FILE)
$(PKG)_DEPS     := cc qt6-qtbase qt6-qtdeclarative qt6-qtsvg \
                   kf6-karchive kf6-kcolorscheme kf6-kcompletion kf6-kconfig \
                   kf6-kconfigwidgets kf6-kdnssd kf6-kguiaddons kf6-kiconthemes \
                   kf6-ki18n kf6-knewstuff kf6-kxmlgui \
                   openal libsndfile

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.kde.org/stable/release-service/' | \
    grep -o 'href="[0-9]*\.[0-9]*\.[0-9]*' | \
    $(SED) 's/href="//' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DBUILD_TESTING=OFF
    cd '$(BUILD_DIR)' && $(TARGET)-cmake --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && $(TARGET)-cmake --install .
endef
