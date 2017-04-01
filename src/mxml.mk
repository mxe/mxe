# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mxml
$(PKG)_WEBSITE  := https://michaelrsweet.github.io/
$(PKG)_DESCR    := Mini-XML
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := c8a2f57
$(PKG)_CHECKSUM := 571f63e2929d756dc9a635f2e7b2d032604d92a7a568dc0849a16dd12cc30330
$(PKG)_GH_CONF  := tonytheodore/mxml/cmake
$(PKG)_DEPS     := gcc pthreads

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DENABLE_THREADS=ON
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-mxml.exe' \
        `'$(TARGET)-pkg-config' mxml --cflags --libs`
endef
