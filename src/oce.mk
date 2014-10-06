# This file is part of MXE.
# See index.html for further information.

PKG             := oce
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.16
$(PKG)_CHECKSUM := c3882249e1afc3c6a170e8e31a45e25d4be3e3b2
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
        -DOCE_INSTALL_CMAKE_DATA_DIR=$(PREFIX)/$(TARGET)/lib/cmake/OCE \
        -DFREETYPE_INCLUDE_DIRS=$(PREFIX)/$(TARGET)/include/freetype2
        
    $(MAKE) -C '$(1)' -j '$(JOBS)' install VERBOSE=1
    
    cd '$(1)/examples/find_package_oce' && cmake . -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'
    $(MAKE) -C '$(1)/examples/find_package_oce'
endef

$(PKG)_BUILD_i686-pc-mingw32 :=
