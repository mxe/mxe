# This file is part of MXE.
# See index.html for further information.

PKG             := xvidcore
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.3
$(PKG)_CHECKSUM := 9e6bb7f7251bca4615c2221534d4699709765ff019ab0366609f219b0158499d
$(PKG)_SUBDIR   := xvidcore/build/generic
$(PKG)_FILE     := xvidcore-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.xvid.org/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pthreads yasm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://labs.xvid.com/source/' | \
    $(SED) -n 's,.*xvidcore-\([0-9][^ ]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,yasm_prog="yasm",yasm_prog="$(TARGET)-yasm",' '$(1)/configure.in'
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j 1 BUILD_DIR='build' $(if $(BUILD_STATIC),SHARED,STATIC)_LIB=
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/../../src/xvid.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib' '$(PREFIX)/$(TARGET)/bin'
    $(INSTALL) -m644 '$(1)/build/xvidcore.$(LIB_SUFFIX)' '$(PREFIX)/$(TARGET)/$(if $(BUILD_STATIC),lib,bin)/'
    $(if $(BUILD_STATIC), \
        ln -sf '$(PREFIX)/$(TARGET)/lib/xvidcore.$(LIB_SUFFIX)' '$(PREFIX)/$(TARGET)/lib/libxvidcore.$(LIB_SUFFIX)', \
        mv '$(1)/build/xvidcore.dll.a' '$(1)/build/libxvidcore.dll.a' && \
        $(INSTALL) -m644 '$(1)/build/libxvidcore.dll.a' '$(PREFIX)/$(TARGET)/lib/')
endef

define $(PKG)_BUILD_x86_64-w64-mingw32
    $(SED) -i 's,yasm_prog="yasm",yasm_prog="$(TARGET)-yasm -DNO_PREFIX",' '$(1)/configure.in'
    $($(PKG)_BUILD)
endef
