# This file is part of MXE. See LICENSE.md for licensing information.
PKG             := kcoreaddons
$(PKG)_VERSION  := 5.49.0
$(PKG)_CHECKSUM := 12afb12f79505614f6d5624d6c39b90b5fc39e4b1b5ddb2203622bbeb6144203
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_HOME     := http://download.kde.org/stable/frameworks
$(PKG)_URL      := $($(PKG)_HOME)/$(basename $($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_DEPS     := qtbase extra-cmake-modules

define $(PKG)_UPDATE
    $(WGET) -q -O- http://download.kde.org/stable/frameworks/ | \
    $(SED) -n 's,.*\([0-9]\+\.[0-9]\+\)/.*,\1.0,p' | \
	tail -1
endef

define $(PKG)_BUILD
	cd "$(1)/src/desktoptojson" && \
		$(BUILD_CXX) -std=c++11 -fPIC \
		$(shell pkg-config --cflags Qt5Core --libs Qt5Core) \
		-DBUILDING_DESKTOPTOJSON_TOOL \
		-o $(PREFIX)/bin/desktoptojson \
		main.cpp desktoptojson.cpp ../lib/plugin/desktopfileparser.cpp

    mkdir "$(1)/build"
    cd "$(1)/build" && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE="$(CMAKE_TOOLCHAIN_FILE)" \
        -DCMAKE_BUILD_TYPE=Release \
        -DKDE_INSTALL_USE_QT_SYS_PATHS=ON -DKDE_L10N_AUTO_TRANSLATIONS=ON \
        -DBUILD_TESTING=OFF
    $(MAKE) -C "$(1)/build" -j $(JOBS) install
endef
