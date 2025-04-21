# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mariadb-connector-c
$(PKG)_WEBSITE  := https://mariadb.com
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.5
$(PKG)_CHECKSUM := 07803adff502edf9b294ba1953cd99e2729d728bcb13c20f823633f7507040a6
$(PKG)_GH_CONF  := mariadb-corporation/mariadb-connector-c/releases,v
$(PKG)_DEPS     := cc dlfcn-win32 openssl zlib zstd

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' \
        -DDISABLE_SHARED=$(CMAKE_STATIC_BOOL) \
        -DDISABLE_STATIC=$(CMAKE_SHARED_BOOL) \
        -DWITH_EXTERNAL_ZLIB=ON \
        -DWITH_UNIT_TESTS=OFF \
        '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 VERBOSE=1 install

    # mariadb_config for target system is not useful. We use pkg-config instead anyway.
    rm '$(PREFIX)/$(TARGET)/bin/mariadb_config.exe'
    # Normalize names of static library and shared library stub to match libmariadb.pc. Move dll to bin.
    $(if $(BUILD_STATIC),
        mv '$(PREFIX)/$(TARGET)/lib/mariadb/libmariadbclient.a' '$(PREFIX)/$(TARGET)/lib/mariadb/libmariadb.a',
        mv '$(PREFIX)/$(TARGET)/lib/mariadb/liblibmariadb.dll.a' '$(PREFIX)/$(TARGET)/lib/mariadb/libmariadb.a'
        mv '$(PREFIX)/$(TARGET)/lib/mariadb/libmariadb.dll' '$(PREFIX)/$(TARGET)/bin/')

    # build test
    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' libmariadb --cflags --libs`
endef
