# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := hiredis
$(PKG)_WEBSITE  := https://github.com/redis/hiredis
$(PKG)_DESCR    := HIREDIS
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.2
$(PKG)_CHECKSUM := e0ab696e2f07deb4252dda45b703d09854e53b9703c7d52182ce5a22616c3819
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
         '$(1)' 
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1

    # Test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -pedantic \
        '$(SOURCE_DIR)/test.c' -o '$(PREFIX)/$(TARGET)/bin/test-hiredis.exe' \
        `'$(TARGET)-pkg-config' hiredis --cflags --libs`
endef
