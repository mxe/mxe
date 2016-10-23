# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := protobuf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.0
$(PKG)_CHECKSUM := 0a0ae63cbffc274efb573bdde9a253e3f32e458c41261df51c5dbc5ad541e8f7
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/google/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc zlib googlemock googletest

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, google/protobuf, v)
endef

define $(PKG)_BUILD
# Zero step: put googlemock and googletest to the source directory.
    $(call PREPARE_PKG_SOURCE,googlemock,$(1))
    cd '$(1)' && mv '$(googlemock_SUBDIR)' gmock
    $(call PREPARE_PKG_SOURCE,googletest,$(1))
    cd '$(1)' && mv '$(googletest_SUBDIR)' gmock/gtest
# First step: Build for host system in order to create "protoc" binary.
    cd '$(1)' && ./autogen.sh && ./configure \
        --disable-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    cp '$(1)/src/protoc' '$(PREFIX)/bin/$(TARGET)-protoc'
    $(MAKE) -C '$(1)' -j 1 distclean
# Second step: Build for target system.
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-zlib \
        --with-protoc='$(PREFIX)/bin/$(TARGET)-protoc'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-protobuf.exe' \
        `'$(TARGET)-pkg-config' protobuf --cflags --libs`
endef
