# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := coda
$(PKG)_WEBSITE  := https://stcorp.nl/coda/
$(PKG)_DESCR    := CODA
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.18.3
$(PKG)_CHECKSUM := e0f72ed7927431748907b57b3fcfa7515ee071162f138e784555d6ca377b9ffe
$(PKG)_GH_CONF  := stcorp/coda/releases/latest
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-idl \
        --disable-matlab \
        --disable-python \
        --without-hdf5 \
        --without-hdf4
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install-libLTLIBRARIES install-nodist_includeHEADERS install-fortranDATA

    '$(TARGET)-gcc' \
        -std=c99 -W -Wall -Werror -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-coda.exe' \
        -lcoda
endef
