# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := assimp
$(PKG)_WEBSITE  := https://www.assimp.org/
$(PKG)_DESCR    := Assimp Open Asset Import Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.0.2
$(PKG)_CHECKSUM := d1822d9a19c9205d6e8bc533bf897174ddb360ce504680f294170cc1d6319751
$(PKG)_GH_CONF  := assimp/assimp/tags, v
$(PKG)_DEPS     := cc minizip

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
        -DASSIMP_BUILD_TESTS=OFF \
        -DCMAKE_C_FLAGS='-Wno-error=array-bounds -Wno-error=maybe-uninitialized' \
        -DCMAKE_CXX_FLAGS='-Wno-error=array-bounds -Wno-error=maybe-uninitialized' \
        '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-g++' \
        -W -Wall -Werror -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-assimp.exe' \
        `'$(TARGET)-pkg-config' assimp minizip --cflags --libs`
endef
