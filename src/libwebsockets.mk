# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libwebsockets
$(PKG)_WEBSITE  := https://libwebsockets.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.2
$(PKG)_CHECKSUM := 73012d7fcf428dedccc816e83a63a01462e27819d5537b8e0d0c7264bfacfad6
$(PKG)_GH_CONF  := warmcat/libwebsockets/tags, v
$(PKG)_DEPS     := cc openssl zlib

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DLWS_WITH_STATIC=$(CMAKE_STATIC_BOOL) \
        -DLWS_WITH_SHARED=$(CMAKE_SHARED_BOOL) \
        -DLWS_WITHOUT_TESTAPPS=ON \
        -DLWS_USE_EXTERNAL_ZLIB=ON
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
