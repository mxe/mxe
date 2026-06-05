# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := kpat
$(PKG)_WEBSITE  := https://apps.kde.org/kpat/
$(PKG)_DESCR    := KPat (KDE Patience)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 26.04.1
$(PKG)_CHECKSUM := 35a95123cc98563970f854a73acf063c139670f592bd0076d997230c4c86b27a
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
    # Patch per evitare che KPat vada in crash/exit(1) su Windows a causa dell'assenza di DBus
    $(SED) -i 's/KDBusService::Multiple/KDBusService::Multiple | KDBusService::NoExitOnFailure/' '$(SOURCE_DIR)/src/main.cpp'
    
    cd '$(BUILD_DIR)' && $(KF6_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DBUILD_TESTING=OFF \
        -DBUILD_DOC=OFF
    
    cd '$(BUILD_DIR)' && $(TARGET)-cmake --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && $(TARGET)-cmake --install .
    
    # --- FASE DI DEPLOYMENT ---
    # Creiamo la cartella dist per l'app standalone
    mkdir -p '$(PREFIX)/$(TARGET)/dist/kpat'
    
    # Copiamo l'eseguibile principale
    cp '$(PREFIX)/$(TARGET)/qt6/bin/kpat.exe' '$(PREFIX)/$(TARGET)/dist/kpat/'
    # Risolviamo e copiamo SOLO le DLL strettamente necessarie per kpat.exe
    '$(TOP_DIR)/tools/copydlldeps.sh' -c \
        -d '$(PREFIX)/$(TARGET)/dist/kpat/' \
        -S "$(PREFIX)/$(TARGET)/qt6/bin $(PREFIX)/$(TARGET)/bin" \
        -f '$(PREFIX)/$(TARGET)/dist/kpat/kpat.exe'
    
    # Copiamo TUTTI i plugin Qt6/KF6 mantenendo la struttura (platforms, imageformats, styles, ecc.)
    cp -r '$(PREFIX)/$(TARGET)/qt6/plugins/'* '$(PREFIX)/$(TARGET)/dist/kpat/' || true
    
    # Copiamo i moduli QML
    cp -r '$(PREFIX)/$(TARGET)/qt6/qml' '$(PREFIX)/$(TARGET)/dist/kpat/' || true
    
    # Risolviamo le dipendenze di tutte le DLL appena copiate (plugins e qml)
    '$(TOP_DIR)/tools/copydlldeps.sh' -c \
        -d '$(PREFIX)/$(TARGET)/dist/kpat/' \
        -S "$(PREFIX)/$(TARGET)/qt6/bin $(PREFIX)/$(TARGET)/bin" \
        -F '$(PREFIX)/$(TARGET)/dist/kpat/'
    
    # Copiamo TUTTI i file data (traduzioni, ui, icone, ecc.)
    cp -r '$(PREFIX)/$(TARGET)/qt6/bin/data' '$(PREFIX)/$(TARGET)/dist/kpat/' || true
    
    # Creiamo il file qt.conf per risolvere i percorsi hardcoded in ambiente standalone
    echo "[Paths]" > '$(PREFIX)/$(TARGET)/dist/kpat/qt.conf'
    echo "Prefix = ." >> '$(PREFIX)/$(TARGET)/dist/kpat/qt.conf'
    echo "Plugins = ." >> '$(PREFIX)/$(TARGET)/dist/kpat/qt.conf'
    echo "Data = data" >> '$(PREFIX)/$(TARGET)/dist/kpat/qt.conf'
    echo "Qml2Imports = qml" >> '$(PREFIX)/$(TARGET)/dist/kpat/qt.conf'
endef
