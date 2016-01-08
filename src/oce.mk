# This file is part of MXE.
# See index.html for further information.

PKG             := oce
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.16.1
$(PKG)_CHECKSUM := d31030c8da4a1b33f767d0d59895a995c8eabc8fc65cbe0558734f6021ea2f57
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
    cd '$(1)' && cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DOCE_BUILD_SHARED_LIB=$(if $(BUILD_STATIC),FALSE,TRUE) \
        -DOCE_INSTALL_PREFIX=$(PREFIX)/$(TARGET) \
        -DOCE_INSTALL_BIN_DIR=$(PREFIX)/$(TARGET)/bin \
        -DOCE_INSTALL_LIB_DIR=$(PREFIX)/$(TARGET)/lib \
        -DOCE_INSTALL_CMAKE_DATA_DIR=$(PREFIX)/$(TARGET)/lib/cmake/OCE

    $(MAKE) -C '$(1)' -j '$(JOBS)' install VERBOSE=1

    cd '$(1)/examples/find_package_oce' && cmake . -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'
    $(MAKE) -C '$(1)/examples/find_package_oce'
endef

