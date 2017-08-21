# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := oce
$(PKG)_WEBSITE  := https://github.com/tpaviot/oce
$(PKG)_DESCR    := Open CASCADE Community Edition
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.18.1
$(PKG)_CHECKSUM := 1acf5da4bffa3592ca9f3535af9b927b79fcfeadcb81e9963e89aec192929a6c
$(PKG)_GH_CONF  := tpaviot/oce,OCE-
$(PKG)_DEPS     := gcc freetype

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DOCE_BUILD_SHARED_LIB=$(CMAKE_SHARED_BOOL) \
        -DOCE_INSTALL_PREFIX=$(PREFIX)/$(TARGET) \
        -DOCE_INSTALL_BIN_DIR=$(PREFIX)/$(TARGET)/bin \
        -DOCE_INSTALL_LIB_DIR=$(PREFIX)/$(TARGET)/lib \
        -DOCE_INSTALL_CMAKE_DATA_DIR=$(PREFIX)/$(TARGET)/lib/cmake/OCE \
        -DOCE_AUTOINSTALL_DEPENDENT_LIBS=OFF

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    cd '$(SOURCE_DIR)/examples/find_package_oce' && '$(TARGET)-cmake' .
    $(MAKE) -C '$(SOURCE_DIR)/examples/find_package_oce'
endef

