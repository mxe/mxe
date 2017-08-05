# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mxml
$(PKG)_WEBSITE  := https://michaelrsweet.github.io/mxml/
$(PKG)_DESCR    := Mini-XML
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.10
$(PKG)_CHECKSUM := bbc8cc3ed5afb5482f531949f5de86b6d24ea5d85bce7b35c49917c300159da9
$(PKG)_GH_CONF  := michaelrsweet/mxml, release-
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
