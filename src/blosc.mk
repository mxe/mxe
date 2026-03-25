# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := blosc
$(PKG)_WEBSITE  := https://www.blosc.org
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.21.6
$(PKG)_CHECKSUM := 9fcd60301aae28f97f1301b735f966cc19e7c49b6b4321b839b4579a0c156f38
$(PKG)_GH_CONF  := blosc/c-blosc/tags,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DBUILD_SHARED=ON \
        -DBUILD_STATIC=$(CMAKE_STATIC_BOOL)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-blosc.exe' \
        `'$(TARGET)-pkg-config' blosc --cflags --libs`

endef
