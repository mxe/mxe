# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := assimp
$(PKG)_WEBSITE  := https://assimp.sourceforge.io/
$(PKG)_DESCR    := Assimp Open Asset Import Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.1.0
$(PKG)_CHECKSUM := 3520b1e9793b93a2ca3b797199e16f40d61762617e072f2d525fad70f9678a71
$(PKG)_GH_CONF  := assimp/assimp/tags, v
$(PKG)_DEPS     := cc boost minizip irrxml

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
        -DASSIMP_BUILD_ASSIMP_TOOLS=OFF \
        -DASSIMP_BUILD_SAMPLES=OFF \
        -DASSIMP_BUILD_TESTS=OFF \
        -DSYSTEM_IRRXML=ON \
        '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic -std=c++11 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-assimp.exe' \
        `'$(TARGET)-pkg-config' assimp minizip --cflags --libs`
endef
