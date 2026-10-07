# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := hiredis
$(PKG)_WEBSITE  := https://github.com/redis/hiredis
$(PKG)_DESCR    := HIREDIS
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.1
$(PKG)_CHECKSUM := ca3180359a8b1275838a45415851f8cd5c411e27bdbf18f4823012e45507d2e4
$(PKG)_GH_CONF  := redis/hiredis/releases,v
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_URL      := https://github.com/redis/hiredis/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc openssl

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
            -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
            -DCMAKE_INSTALL_LIBDIR='$(PREFIX)/$(TARGET)/lib' \
            -DENABLE_SSL=ON \
            -DCMAKE_BUILD_TYPE="Release" \
            -DENABLE_EXAMPLES=OFF \
            -DCMAKE_C_FLAGS='-Wno-int-conversion' \
         '$(1)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1

    # Test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -pedantic \
        '$(SOURCE_DIR)/test.c' -o '$(PREFIX)/$(TARGET)/bin/test-hiredis.exe' \
        `'$(TARGET)-pkg-config' hiredis --cflags --libs`
endef
