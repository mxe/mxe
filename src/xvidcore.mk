# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xvidcore
$(PKG)_WEBSITE  := https://www.xvid.com/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.7
$(PKG)_CHECKSUM := abbdcbd39555691dd1c9b4d08f0a031376a3b211652c0d8b3b8aa9be1303ce2d
$(PKG)_SUBDIR   := xvidcore
$(PKG)_FILE     := xvidcore-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://downloads.xvid.com/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := cc pthreads yasm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://labs.xvid.com/source/' | \
    $(SED) -n 's,.*xvidcore-\([0-9][^ ]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,yasm_prog="yasm",yasm_prog="$(TARGET)-yasm",' \
        '$(SOURCE_DIR)/build/generic/configure.in'
    cd '$(SOURCE_DIR)/build/generic' && autoreconf -fi
    cd '$(SOURCE_DIR)/build/generic' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        CFLAGS='-std=gnu99'
    $(MAKE) -C '$(SOURCE_DIR)/build/generic' -j 1 BUILD_DIR='$(BUILD_DIR)' \
        $(if $(BUILD_STATIC),SHARED,STATIC)_LIB=
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(SOURCE_DIR)/src/xvid.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib' '$(PREFIX)/$(TARGET)/bin'
    $(INSTALL) -m644 '$(BUILD_DIR)/xvidcore.$(LIB_SUFFIX)' \
        '$(PREFIX)/$(TARGET)/$(if $(BUILD_STATIC),lib,bin)/'
    $(if $(BUILD_STATIC), \
        ln -sf '$(PREFIX)/$(TARGET)/lib/xvidcore.$(LIB_SUFFIX)' '$(PREFIX)/$(TARGET)/lib/libxvidcore.$(LIB_SUFFIX)', \
        mv '$(BUILD_DIR)/xvidcore.dll.a' '$(BUILD_DIR)/libxvidcore.dll.a' && \
        $(INSTALL) -m644 '$(BUILD_DIR)/libxvidcore.dll.a' '$(PREFIX)/$(TARGET)/lib/'
    )
endef

define $(PKG)_BUILD_x86_64-w64-mingw32
    $(SED) -i 's,yasm_prog="yasm",yasm_prog="$(TARGET)-yasm -DNO_PREFIX",' \
        '$(SOURCE_DIR)/build/generic/configure.in'
    $($(PKG)_BUILD)
endef
