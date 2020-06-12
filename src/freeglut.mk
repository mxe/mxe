# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := freeglut
$(PKG)_WEBSITE  := https://freeglut.sourceforge.io/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.1
$(PKG)_CHECKSUM := d4000e02102acaf259998c870e25214739d1f16f67f99cb35e4f46841399da68
$(PKG)_SUBDIR   := freeglut-$($(PKG)_VERSION)
$(PKG)_FILE     := freeglut-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/freeglut/freeglut/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/freeglut/files/freeglut/' | \
    $(SED) -n 's,.*freeglut-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DFREEGLUT_GLES=OFF \
        -DFREEGLUT_BUILD_DEMOS=OFF \
        -DFREEGLUT_REPLACE_GLUT=ON \
        -DFREEGLUT_BUILD_STATIC_LIBS=$(CMAKE_STATIC_BOOL) \
        -DFREEGLUT_BUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-freeglut.exe' \
        `'$(TARGET)-pkg-config' glut --cflags --libs`
endef
