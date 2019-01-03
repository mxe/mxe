# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := freeglut
$(PKG)_WEBSITE  := https://freeglut.sourceforge.io/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.0
$(PKG)_CHECKSUM := 2a43be8515b01ea82bcfa17d29ae0d40bd128342f0930cd1f375f1ff999f76a2
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
