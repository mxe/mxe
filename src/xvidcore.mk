# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xvidcore
$(PKG)_WEBSITE  := https://www.xvid.com/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.4
$(PKG)_CHECKSUM := 4e9fd62728885855bc5007fe1be58df42e5e274497591fec37249e1052ae316f
$(PKG)_SUBDIR   := xvidcore
$(PKG)_FILE     := xvidcore-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.xvid.org/downloads/$($(PKG)_FILE)
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
        $(MXE_CONFIGURE_OPTS)
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
