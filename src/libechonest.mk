# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libechonest
$(PKG)_WEBSITE  := https://github.com/lfranchi/libechonest
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.1
$(PKG)_CHECKSUM := ab961ab952df30c5234b548031594d7e281e7c9f2a9d1ce91fe5421ddde85e7c
$(PKG)_GH_CONF  := lfranchi/libechonest/tags
$(PKG)_DEPS     := cc qtbase

$(PKG)_QT_SUFFIX := 5
$(PKG)_QT4_BOOL  := OFF

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DECHONEST_BUILD_TESTS=OFF \
        -DBUILD_WITH_QT4=$($(PKG)_QT4_BOOL)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-g++' \
        -W -Wall -Werror -std=c++11 -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' libechonest$($(PKG)_QT_SUFFIX) --cflags --libs`
endef
