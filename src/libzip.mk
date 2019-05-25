# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libzip
$(PKG)_WEBSITE  := https://libzip.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5.2
$(PKG)_CHECKSUM := 905ae156f7590f4f3ab251cb79a0a48023848a7ae176143ec9467a9421bdb699
$(PKG)_GH_CONF  := nih-at/libzip/releases,rel-,,,-
$(PKG)_DEPS     := cc bzip2 zlib

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DENABLE_GNUTLS=OFF \
        -DENABLE_OPENSSL=OFF \
        -DENABLE_COMMONCRYPTO=OFF
    $(MAKE) -C '$(BUILD_DIR)/lib' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/lib' -j 1 install

    $(INSTALL) -m644 '$(BUILD_DIR)/zipconf.h' '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(BUILD_DIR)/libzip.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libzip.exe' \
        `'$(TARGET)-pkg-config' libzip --cflags --libs`
endef
