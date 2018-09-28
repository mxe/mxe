# This file is part of MXE. See LICENSE.md for licensing information.
PKG             := kdeclarative
$(PKG)_VERSION  := 5.49.0
$(PKG)_CHECKSUM  := 49bbdf17f1ba3212b96ab8ebfbc31c78b3772b04b2f3c9c4b49a74c7d1e2ea4d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_HOME     := http://download.kde.org/stable/frameworks
$(PKG)_URL      := $($(PKG)_HOME)/$(basename $($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_DEPS     := qtbase extra-cmake-modules \
	kconfig ki18n kiconthemes kio kwidgetsaddons \
	kwindowsystem kglobalaccel kguiaddons kpackage

define $(PKG)_UPDATE
    $(WGET) -q -O- http://download.kde.org/stable/frameworks/ | \
    $(SED) -n 's,.*\([0-9]\+\.[0-9]\+\)/.*,\1.0,p' | \
	tail -1
endef

define $(PKG)_BUILD
    mkdir "$(1)/build"
    cd "$(1)/build" && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE="$(CMAKE_TOOLCHAIN_FILE)" \
        -DCMAKE_CROSSCOMPILING=ON \
        -DKF5_HOST_TOOLING=/usr/lib/x86_64-linux-gnu/cmake \
        -DKCONFIGCOMPILER_PATH=/usr/lib/x86_64-linux-gnu/cmake/KF5Config/KF5ConfigCompilerTargets.cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DKDE_INSTALL_USE_QT_SYS_PATHS=ON -DKDE_L10N_AUTO_TRANSLATIONS=ON \
        -DBUILD_TESTING=OFF
    $(MAKE) -C "$(1)/build" -j $(JOBS) install
endef
