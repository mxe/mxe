# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := assimp
$(PKG)_WEBSITE  := https://www.assimp.org/
$(PKG)_DESCR    := Assimp Open Asset Import Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.4.1
$(PKG)_CHECKSUM := a1bf71c4eb851ca336bba301730cd072b366403e98e3739d6a024f6313b8f954
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
