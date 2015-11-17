# This file is part of MXE.
# See index.html for further information.

PKG             := coin
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.3
$(PKG)_CHECKSUM := 583478c581317862aa03a19f14c527c3888478a06284b9a46a0155fa5886d417
$(PKG)_SUBDIR   := Coin-$($(PKG)_VERSION)
$(PKG)_FILE     := Coin-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://bitbucket.org/Coin3D/coin/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://bitbucket.org/Coin3D/coin/downloads' | \
    $(SED) -n 's,.*Coin-\([0-9.]*\).tar.gz.*,\1,p' | \
    $(SORT) -V | \
    $(TAIL) -n1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-debug \
        --disable-symbols \
        --enable-compact \
        --without-openal \
        --without-fontconfig \
        --without-spidermonkey \
        --without-freetype \
        --without-zlib \
        --without-bzip2 \
        --without-x \
        $(if $(BUILD_STATIC), \
            --enable-static=yes --enable-shared=no, \
            --enable-static=no --enable-shared=yes)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    '$(TARGET)-g++' \
        -W -Wall -pedantic '$(2).cpp' \
	$(if $(BUILD_STATIC), \
	    -DCOIN_NOT_DLL, \
	    -DCOIN_DLL) \
        -o '$(PREFIX)/$(TARGET)/bin/test-coin.exe' \
        `'$(PREFIX)/$(TARGET)/bin/coin-config' --libs` \
	-I`'$(PREFIX)/$(TARGET)/bin/coin-config' --includedir`
endef
