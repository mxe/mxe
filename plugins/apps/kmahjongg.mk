# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := kmahjongg
$(PKG)_WEBSITE  := https://apps.kde.org/it/kmahjongg/
$(PKG)_DESCR    := KMahjongg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 26.04.3
$(PKG)_CHECKSUM := 8e4575a50d37a6259b7c4381c4243d0a05d64847c620c5af58c34a83ae6ce38b
$(PKG)_SUBDIR   := kmahjongg-$($(PKG)_VERSION)
$(PKG)_FILE     := kmahjongg-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.kde.org/stable/release-service/$($(PKG)_VERSION)/src/$($(PKG)_FILE)
$(PKG)_DEPS     := cc qt6-qtbase qt6-qtsvg qt6-qtdeclarative \
                   kf6-kconfig kf6-kcoreaddons kf6-kcrash kf6-kdbusaddons \
                   kf6-ki18n kf6-knewstuff kf6-kxmlgui \
                   kde-libkdegames kde-libkmahjongg

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.kde.org/stable/release-service/' | \
    grep -o 'href="[0-9]*\.[0-9]*\.[0-9]*' | \
    $(SED) 's/href="//' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    # Patch to prevent KMahjongg from crashing/exiting(1) on Windows due to missing DBus
    $(SED) -i 's/KDBusService service;/KDBusService service(KDBusService::Multiple | KDBusService::NoExitOnFailure);/' '$(SOURCE_DIR)/src/main.cpp'
    
    cd '$(BUILD_DIR)' && $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DBUILD_TESTING=OFF \
        -DBUILD_DOC=OFF
    
    cd '$(BUILD_DIR)' && $(TARGET)-cmake --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && $(TARGET)-cmake --install .
    
    # --- DEPLOYMENT PHASE ---
    # Create the dist folder for the standalone app
    mkdir -p '$(PREFIX)/$(TARGET)/dist/kmahjongg'
    
    # Copy the main executable
    cp '$(PREFIX)/$(TARGET)/qt6/bin/kmahjongg.exe' '$(PREFIX)/$(TARGET)/dist/kmahjongg/'
    
    # Resolve and copy ONLY the strictly necessary DLLs using the native MXE tool
    '$(TOP_DIR)/tools/copydlldeps.sh' -c \
        -d '$(PREFIX)/$(TARGET)/dist/kmahjongg/' \
        -S "$(PREFIX)/$(TARGET)/qt6/bin $(PREFIX)/$(TARGET)/bin" \
        -f '$(PREFIX)/$(TARGET)/dist/kmahjongg/kmahjongg.exe'
    
    # Copy ALL Qt6/KF6 plugins preserving the structure (platforms, imageformats, styles, etc.)
    cp -r '$(PREFIX)/$(TARGET)/qt6/plugins/'* '$(PREFIX)/$(TARGET)/dist/kmahjongg/' || true
    
    # Copy QML modules
    cp -r '$(PREFIX)/$(TARGET)/qt6/qml' '$(PREFIX)/$(TARGET)/dist/kmahjongg/' || true
    
    # Resolve dependencies for all newly copied DLLs (plugins and qml)
    '$(TOP_DIR)/tools/copydlldeps.sh' -c \
        -d '$(PREFIX)/$(TARGET)/dist/kmahjongg/' \
        -S "$(PREFIX)/$(TARGET)/qt6/bin $(PREFIX)/$(TARGET)/bin" \
        -F '$(PREFIX)/$(TARGET)/dist/kmahjongg/'
    
    # Copy specific data files required by kmahjongg directly into the app folder
    mkdir -p '$(PREFIX)/$(TARGET)/dist/kmahjongg/data'
    cp -r '$(PREFIX)/$(TARGET)/qt6/bin/data/kmahjongg' '$(PREFIX)/$(TARGET)/dist/kmahjongg/data/' || true
    cp -r '$(PREFIX)/$(TARGET)/qt6/bin/data/kmahjongglib' '$(PREFIX)/$(TARGET)/dist/kmahjongg/data/' || true
    cp -r '$(PREFIX)/$(TARGET)/qt6/bin/data/icons' '$(PREFIX)/$(TARGET)/dist/kmahjongg/data/' || true
    cp -r '$(PREFIX)/$(TARGET)/qt6/bin/data/locale' '$(PREFIX)/$(TARGET)/dist/kmahjongg/data/' || true
    
    # Create the qt.conf file to resolve hardcoded paths in a standalone environment
    echo "[Paths]" > '$(PREFIX)/$(TARGET)/dist/kmahjongg/qt.conf'
    echo "Prefix = ." >> '$(PREFIX)/$(TARGET)/dist/kmahjongg/qt.conf'
    echo "Plugins = ." >> '$(PREFIX)/$(TARGET)/dist/kmahjongg/qt.conf'
    echo "Data = data" >> '$(PREFIX)/$(TARGET)/dist/kmahjongg/qt.conf'
    echo "Qml2Imports = qml" >> '$(PREFIX)/$(TARGET)/dist/kmahjongg/qt.conf'
endef
