# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := assimp
$(PKG)_WEBSITE  := https://assimp.sourceforge.io/
$(PKG)_DESCR    := Assimp Open Asset Import Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2
$(PKG)_CHECKSUM := 187f825c563e84b1b17527a4da0351aa3d575dfd696a9d204ae4bb19ee7df94a
$(PKG)_GH_CONF  := assimp/assimp/tags, v
$(PKG)_DEPS     := cc boost

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
        -DASSIMP_ENABLE_BOOST_WORKAROUND=OFF \
        -DASSIMP_BUILD_ASSIMP_TOOLS=OFF \
        -DASSIMP_BUILD_SAMPLES=OFF \
        -DASSIMP_BUILD_TESTS=OFF \
        '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-assimp.exe' \
        `'$(TARGET)-pkg-config' assimp --cflags --libs`
endef
