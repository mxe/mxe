# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := yaml-cpp
$(PKG)_WEBSITE  := https://github.com/jbeder/yaml-cpp
$(PKG)_DESCR    := A YAML parser and emitter for C++
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.5.3
$(PKG)_CHECKSUM := 3492d9c1f4319dfd5588f60caed7cec3f030f7984386c11ed4b39f8e3316d763
$(PKG)_SUBDIR   := $(PKG)-release-$($(PKG)_VERSION)
$(PKG)_FILE     := yaml-cpp-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/jbeder/yaml-cpp/archive/release-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc boost

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, jbeder/yaml-cpp, \(yaml-cpp-\|release-\))
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS) VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
