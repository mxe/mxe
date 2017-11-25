# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sqlcipher
$(PKG)_WEBSITE  := https://www.zetetic.net/sqlcipher/
$(PKG)_DESCR    := SQLite extension that provides 256 bit AES encryption of database files
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.1
$(PKG)_CHECKSUM := 4172cc6e5a79d36e178d36bd5cc467a938e08368952659bcd95eccbaf0fa4ad4
$(PKG)_GH_CONF  := sqlcipher/sqlcipher/tags, v
$(PKG)_DEPS     := cc openssl readline $(BUILD)~tcl

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        "LIBS=$$($(TARGET)-pkg-config --libs libcrypto)" \
        "CFLAGS=-DSQLITE_HAS_CODEC" \
        config_BUILD_EXEEXT='' \
        config_TARGET_EXEEXT='.exe' \
        --enable-tempstore=yes \
        --disable-tcl \
        --disable-editline \
        --enable-readline \
        --with-readline \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror \
        '$(SOURCE_DIR)/mptest/mptest.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
