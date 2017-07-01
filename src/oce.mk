# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := oce
$(PKG)_WEBSITE  := https://github.com/tpaviot/oce
$(PKG)_DESCR    := Open CASCADE Community Edition
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.17.2
$(PKG)_CHECKSUM := 8d9995360cd531cbd4a7aa4ca5ed969f08ec7c7a37755e2f3d4ef832c1b2f56e
$(PKG)_SUBDIR   := $(PKG)-OCE-$($(PKG)_VERSION)
$(PKG)_FILE     := OCE-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/tpaviot/oce/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc freetype

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/tpaviot/oce/releases' | \
    $(SED) -n 's,.*oce/archive/OCE-\([0-9][^"]*\)\.tar\.gz.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(TARGET)-cmake' '$(1)' \
        -DOCE_BUILD_SHARED_LIB=$(if $(BUILD_STATIC),FALSE,TRUE) \
        -DOCE_INSTALL_PREFIX=$(PREFIX)/$(TARGET) \
        -DOCE_INSTALL_BIN_DIR=$(PREFIX)/$(TARGET)/bin \
        -DOCE_INSTALL_LIB_DIR=$(PREFIX)/$(TARGET)/lib \
        -DOCE_INSTALL_CMAKE_DATA_DIR=$(PREFIX)/$(TARGET)/lib/cmake/OCE \
        -DOCE_AUTOINSTALL_DEPENDENT_LIBS=OFF

    $(MAKE) -C '$(1).build' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(1).build' -j 1 install

    cd '$(1)/examples/find_package_oce' && '$(TARGET)-cmake' .
    $(MAKE) -C '$(1)/examples/find_package_oce'
endef

