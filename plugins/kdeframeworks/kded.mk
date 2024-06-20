# This file is part of MXE. See LICENSE.md for licensing information.
PKG             := kded
$(PKG)_VERSION  := 5.50.0
$(PKG)_CHECKSUM  := 0144e6371f894b1063a1033e05bca17bf76829522e472e2026bf0a0d0815d0c1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_HOME     := https://download.kde.org/stable/frameworks
$(PKG)_URL      := $($(PKG)_HOME)/$(basename $($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_DEPS     := qtbase extra-cmake-modules kconfig kcoreaddons kcrash kdbusaddons kservice kinit

define $(PKG)_UPDATE
    $(WGET) -q -O- https://download.kde.org/stable/frameworks/ | \
    $(SED) -n 's,.*\([0-9]\+\.[0-9]\+\)/.*,\1.0,p' | \
	tail -1
endef

define $(PKG)_BUILD
    mkdir "$(1)/build"
    cd "$(1)/build" && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE="$(CMAKE_TOOLCHAIN_FILE)" \
        -DCMAKE_BUILD_TYPE=Release \
        -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
        -DBUILD_TESTING=OFF
    $(MAKE) -C "$(1)/build" -j $(JOBS)
    $(MAKE) -C "$(1)/build" -j $(JOBS) install
endef
