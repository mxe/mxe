# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := protobuf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6.1
$(PKG)_CHECKSUM := dbbd7bdd2381633995404de65a945ff1a7610b0da14593051b4738c90c6dd164
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/google/protobuf/releases/download/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, google/protobuf, v)
endef

define $(PKG)_BUILD
# First step: Build for host system in order to create "protoc" binary.
    cd '$(1)' && ./configure \
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
