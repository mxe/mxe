# This file is part of MXE. See LICENSE.md for licensing information.
PKG             := kdecoration
$(PKG)_VERSION  := 5.14.0
$(PKG)_CHECKSUM  := f55bc460325a41de58c445a8d10eeecdfd127f3edc3da2b0a0a1d28b3da0f305
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_HOME     := https://download.kde.org/stable/plasma
$(PKG)_URL      := $($(PKG)_HOME)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := qtbase extra-cmake-modules

define $(PKG)_UPDATE
    $(WGET) -q -O- https://download.kde.org/stable/plasma/ | \
    $(SED) -n 's,.*\([0-9]\+\.[0-9]\+\.[0-9]\+\)/.*,\1,p' | \
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
        -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
        -DBUILD_TESTING=OFF
    $(MAKE) -C "$(1)/build" -j $(JOBS) install
endef
