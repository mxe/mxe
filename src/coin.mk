# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := coin
$(PKG)_WEBSITE  := https://bitbucket.org/Coin3D/
$(PKG)_DESCR    := Coin3D
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0.8
$(PKG)_CHECKSUM := bfc293bd3fe67a4835c8f373a0c838e22eb2c565db8d57b9c745db86e57c7969
$(PKG)_GH_CONF  := coin3d/coin/tags, v
$(PKG)_SUBDIR   := coin-$($(PKG)_VERSION)
$(PKG)_FILE     := coin-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc dlfcn-win32

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCOIN_BUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DCOIN_BUILD_TESTS=OFF \
        -DCOIN_BUILD_DOCUMENTATION=OFF \
        -DCOIN_BUILD_EXAMPLES=OFF \
        -DHAVE_SOUND=OFF \
        -DSIM_TIMEVAL_TV_SEC_T=long \
        -DSIM_TIMEVAL_TV_USEC_T=long

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-g++' \
        -W -Wall -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-coin.exe' \
        -D$(if $(BUILD_STATIC),COIN_NOT_DLL,COIN_DLL) \
        `'$(TARGET)-pkg-config' Coin --cflags --libs`
endef
