# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := protobuf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.0
$(PKG)_CHECKSUM := 0a0ae63cbffc274efb573bdde9a253e3f32e458c41261df51c5dbc5ad541e8f7
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/google/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc zlib googlemock googletest
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) := googlemock googletest

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, google/protobuf, v)
endef

define $(PKG)_BUILD
    $(call PREPARE_PKG_SOURCE,googlemock,$(SOURCE_DIR))
    cd '$(SOURCE_DIR)' && mv '$(googlemock_SUBDIR)' gmock
    $(call PREPARE_PKG_SOURCE,googletest,$(SOURCE_DIR))
    cd '$(SOURCE_DIR)' && mv '$(googletest_SUBDIR)' gmock/gtest
    cd '$(SOURCE_DIR)' && ./autogen.sh

    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)'/configure \
        $(MXE_CONFIGURE_OPTS) \
        $(if $(BUILD_CROSS), \
            --with-zlib \
            --with-protoc='$(PREFIX)/$(BUILD)/bin/protoc' \
        )
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    $(if $(BUILD_CROSS),
        '$(TARGET)-g++' \
            -W -Wall -Werror -ansi -pedantic \
            '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-protobuf.exe' \
            `'$(TARGET)-pkg-config' protobuf --cflags --libs`
    )
endef
