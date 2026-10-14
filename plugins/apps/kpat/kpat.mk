# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := kpat
$(PKG)_WEBSITE  := https://apps.kde.org/kpat/
$(PKG)_DESCR    := KPat (KDE Patience)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 26.04.3
$(PKG)_CHECKSUM := 562ab74043bfb77ec57970f757f107ded9d8e3fe13748324009720077ad719cb
$(PKG)_SUBDIR   := kpat-$($(PKG)_VERSION)
$(PKG)_FILE     := kpat-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.kde.org/stable/release-service/$($(PKG)_VERSION)/src/$($(PKG)_FILE)
$(PKG)_DEPS     := cc qt6-qtbase qt6-qtsvg qt6-qtdeclarative \
                   kf6-kcompletion kf6-kconfig kf6-kconfigwidgets kf6-kcoreaddons \
                   kf6-kcrash kf6-kdbusaddons kf6-kguiaddons kf6-ki18n kf6-kio \
                   kf6-knewstuff kf6-kwidgetsaddons kf6-kxmlgui \
                   freecell-solver black-hole-solver kde-libkdegames

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.kde.org/stable/release-service/' | \
    grep -o 'href="[0-9]*\.[0-9]*\.[0-9]*' | \
    $(SED) 's/href="//' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    # Workaround to prevent KPat from crashing/exiting(1) on Windows due to missing DBus process
    $(SED) -i 's/KDBusService::Multiple/KDBusService::Multiple | KDBusService::NoExitOnFailure/' '$(SOURCE_DIR)/src/main.cpp'
    
    # Workaround for GCC 11 parsing bug with [[deprecated]] and __declspec
    $(SED) -i 's/KF 6.0/KF 7.0/' '$(SOURCE_DIR)/CMakeLists.txt'
    
    cd '$(BUILD_DIR)' && $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DBUILD_TESTING=OFF \
        -DBUILD_DOC=OFF
    
    cd '$(BUILD_DIR)' && $(TARGET)-cmake --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && $(TARGET)-cmake --install .
    
    # --- DEPLOYMENT PHASE ---
    # Create the dist folder for the standalone app
    mkdir -p '$(PREFIX)/$(TARGET)/bundle/$(PKG)'
    
    # Copy the main executable
    cp '$(PREFIX)/$(TARGET)/qt6/bin/kpat.exe' '$(PREFIX)/$(TARGET)/bundle/$(PKG)/'
    # Resolve and copy ONLY the strictly necessary DLLs using the native MXE tool
    '$(TOP_DIR)/tools/copydlldeps.sh' -c \
        -d '$(PREFIX)/$(TARGET)/bundle/$(PKG)/' \
        -S "$(PREFIX)/$(TARGET)/qt6/bin $(PREFIX)/$(TARGET)/bin" \
        -f '$(PREFIX)/$(TARGET)/bundle/$(PKG)/kpat.exe'
    
    # Copy Qt6/KF6 plugins
    cp -r '$(PREFIX)/$(TARGET)/qt6/plugins' '$(PREFIX)/$(TARGET)/bundle/$(PKG)/' || true
    
    # Copy QML modules
    cp -r '$(PREFIX)/$(TARGET)/qt6/qml' '$(PREFIX)/$(TARGET)/bundle/$(PKG)/' || true
    
    # Resolve dependencies for all newly copied DLLs (plugins and qml)
    '$(TOP_DIR)/tools/copydlldeps.sh' -c \
        -d '$(PREFIX)/$(TARGET)/bundle/$(PKG)/' \
        -S "$(PREFIX)/$(TARGET)/qt6/bin $(PREFIX)/$(TARGET)/bin" \
        -F '$(PREFIX)/$(TARGET)/bundle/$(PKG)/'
    
    # Copy specific data files required by kpat directly into the app folder
    mkdir -p '$(PREFIX)/$(TARGET)/bundle/$(PKG)/data'
    cp -r '$(PREFIX)/$(TARGET)/qt6/bin/data/kpat' '$(PREFIX)/$(TARGET)/bundle/$(PKG)/data/' || true
    cp -r '$(PREFIX)/$(TARGET)/qt6/bin/data/carddecks' '$(PREFIX)/$(TARGET)/bundle/$(PKG)/data/' || true
    cp -r '$(PREFIX)/$(TARGET)/qt6/bin/data/icons' '$(PREFIX)/$(TARGET)/bundle/$(PKG)/data/' || true
    cp -r '$(PREFIX)/$(TARGET)/qt6/bin/data/locale' '$(PREFIX)/$(TARGET)/bundle/$(PKG)/data/' || true
    
    # Create the qt.conf file to resolve hardcoded paths in a standalone environment
    echo "[Paths]" > '$(PREFIX)/$(TARGET)/bundle/$(PKG)/qt.conf'
    echo "Prefix = ." >> '$(PREFIX)/$(TARGET)/bundle/$(PKG)/qt.conf'
    echo "Plugins = plugins" >> '$(PREFIX)/$(TARGET)/bundle/$(PKG)/qt.conf'
    echo "Data = data" >> '$(PREFIX)/$(TARGET)/bundle/$(PKG)/qt.conf'
    echo "Qml2Imports = qml" >> '$(PREFIX)/$(TARGET)/bundle/$(PKG)/qt.conf'
endef
