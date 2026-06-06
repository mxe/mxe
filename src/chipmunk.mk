# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := chipmunk
$(PKG)_WEBSITE  := https://chipmunk-physics.net/
$(PKG)_DESCR    := Chipmunk Physics
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.0.3
$(PKG)_CHECKSUM := 1e6f093812d6130e45bdf4cb80280cb3c93d1e1833d8cf989d554d7963b7899a
$(PKG)_GH_CONF  := slembcke/Chipmunk2D/tags, Chipmunk-
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_DEMOS=OFF \
        -DINSTALL_DEMOS=OFF \
        -DINSTALL_STATIC=$(CMAKE_STATIC_BOOL)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic -std=c99 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-chipmunk.exe' \
        -lchipmunk
endef
