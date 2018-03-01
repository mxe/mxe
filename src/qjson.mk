# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qjson
$(PKG)_WEBSITE  := https://qjson.sourceforge.io/
$(PKG)_DESCR    := QJson
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.0
$(PKG)_CHECKSUM := e812617477f3c2bb990561767a4cd8b1d3803a52018d4878da302529552610d4
$(PKG)_GH_CONF  := flavio/qjson/tags
$(PKG)_DEPS     := cc qtbase

$(PKG)_QT_SUFFIX := -qt5
$(PKG)_QT4_BOOL  := OFF

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DQT4_BUILD=$($(PKG)_QT4_BOOL)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-g++' \
        -W -Wall -Werror -std=c++11 -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' QJson$($(PKG)_QT_SUFFIX) --cflags --libs`
endef
