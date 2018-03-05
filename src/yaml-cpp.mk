# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := yaml-cpp
$(PKG)_WEBSITE  := https://github.com/jbeder/yaml-cpp
$(PKG)_DESCR    := A YAML parser and emitter for C++
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.6.1
$(PKG)_CHECKSUM := 25ec37e6d82ab8c485926d69a5567741c7263515f8631e5dcb3fb4708e6b0d0d
$(PKG)_GH_CONF  := jbeder/yaml-cpp/releases/latest,yaml-cpp-
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DYAML_CPP_BUILD_TESTS=OFF \
        -DYAML_CPP_BUILD_TOOLS=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS) VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic -std=c++11 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
