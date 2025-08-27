# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mariadb-connector-c
$(PKG)_WEBSITE  := https://mariadb.com
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.7
$(PKG)_CHECKSUM := cf81cd1c71c3199da9d2125aee840cb6083d43e1ea4c60c4be5045bfc7824eba
$(PKG)_GH_CONF  := mariadb-corporation/mariadb-connector-c/releases,v
$(PKG)_DEPS     := cc dlfcn-win32 zlib zstd

define $(PKG)_BUILD
    rm -rf '$(PREFIX)/$(TARGET)/include/mariadb' '$(PREFIX)/$(TARGET)/lib/mariadb'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' \
        -DDISABLE_SHARED=$(CMAKE_STATIC_BOOL) \
        -DDISABLE_STATIC=$(CMAKE_SHARED_BOOL) \
        -DWITH_CURL=OFF \
        -DWITH_EXTERNAL_ZLIB=ON \
        -DWITH_SSL=SCHANNEL \
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
    # workaround for linking to 32-bit shared libmariadb.a
    $(if $(BUILD_SHARED), '$(SED)' -i -e 's/^#define STDCALL __stdcall/#define STDCALL/;' '$(PREFIX)/$(TARGET)/include/mariadb/mysql.h')

    # build test
    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' libmariadb --cflags --libs`
endef
