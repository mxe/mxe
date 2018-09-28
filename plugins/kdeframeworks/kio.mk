# This file is part of MXE. See LICENSE.md for licensing information.
PKG             := kio
$(PKG)_VERSION  := 5.49.0
$(PKG)_CHECKSUM  := f3089c1746dcd86d100b57a011e6f6fcbdf0622bad6f546e63048815de783a67
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_HOME     := http://download.kde.org/stable/frameworks
$(PKG)_URL      := $($(PKG)_HOME)/$(basename $($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_DEPS     := qtbase extra-cmake-modules \
	karchive kcodecs kconfig kcoreaddons kdbusaddons ki18n kitemviews solid kwidgetsaddons kwindowsystem \
	kcompletion kjobwidgets \
	kbookmarks kconfigwidgets kiconthemes knotifications kservice kxmlgui kwallet

define $(PKG)_UPDATE
    $(WGET) -q -O- http://download.kde.org/stable/frameworks/ | \
    $(SED) -n 's,.*\([0-9]\+\.[0-9]\+\)/.*,\1.0,p' | \
	tail -1
endef

define $(PKG)_BUILD
    mkdir "$(1)/build"
    cd "$(1)/build" && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE="$(CMAKE_TOOLCHAIN_FILE)" \
        -DCMAKE_BUILD_TYPE=Release \
        -DKDE_INSTALL_USE_QT_SYS_PATHS=ON -DKDE_L10N_AUTO_TRANSLATIONS=ON \
        -DDESKTOPTOJSON_EXECUTABLE=$(PREFIX)/bin/desktoptojson \
        -DBUILD_TESTING=OFF
    $(MAKE) -C "$(1)/build" -j $(JOBS) install
endef
