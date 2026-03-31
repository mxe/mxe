# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libjpeg-turbo
$(PKG)_WEBSITE  := https://www.libjpeg-turbo.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.4.1
$(PKG)_CHECKSUM := ecae8008e2cc9ade2f2c1bb9d5e6d4fb73e7c433866a056bd82980741571a022
$(PKG)_GH_CONF  := libjpeg-turbo/libjpeg-turbo/releases,,,90,,.tar.gz
$(PKG)_DEPS     := cc yasm
define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DENABLE_SHARED=$(CMAKE_SHARED_BOOL) \
        -DENABLE_STATIC=$(CMAKE_STATIC_BOOL) \
        -DCMAKE_INSTALL_BINDIR='$(PREFIX)/$(TARGET)/bin/$(PKG)' \
        -DCMAKE_INSTALL_INCLUDEDIR='$(PREFIX)/$(TARGET)/include/$(PKG)' \
        -DCMAKE_INSTALL_LIBDIR='$(PREFIX)/$(TARGET)/lib/$(PKG)' \
        -DCMAKE_ASM_NASM_COMPILER=$(TARGET)-yasm
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TOP_DIR)/src/jpeg-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' '$(PREFIX)/$(TARGET)/lib/$(PKG)/pkgconfig/libjpeg.pc' --cflags --libs`
endef
