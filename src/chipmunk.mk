# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := chipmunk
$(PKG)_WEBSITE  := https://chipmunk-physics.net/
$(PKG)_DESCR    := Chipmunk Physics
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.0.2
$(PKG)_CHECKSUM := 6b6d8d5d910c4442fb9c8c4c46a178126d8c21d075cdb3ce439a7f8d8757b0ca
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
