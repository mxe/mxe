# This file is part of MXE.
# See index.html for further information.

PKG             := protobuf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6.1
$(PKG)_CHECKSUM := 2667b7cda4a6bc8a09e5463adf3b5984e08d94e72338277affa8594d8b6e5cd1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/google/$(PKG)/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc zlib googletest

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, google/protobuf, v)
endef

define $(PKG)_BUILD
    $(call PREPARE_PKG_SOURCE,googletest,$(1))
    cd '$(1)' && mv googletest-release-$(googletest_VERSION)/ gtest
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
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-protobuf.exe' \
        `'$(TARGET)-pkg-config' protobuf --cflags --libs`
endef
