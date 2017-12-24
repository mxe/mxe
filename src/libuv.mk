# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libuv
$(PKG)_WEBSITE  := http://libuv.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.1
$(PKG)_CHECKSUM := e83953782c916d7822ef0b94e8115ce5756fab5300cca173f0de5f5b0e0ae928
$(PKG)_SUBDIR   := $(PKG)-v$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-v$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://dist.libuv.org/dist/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, libuv/libuv, v)
endef

define $(PKG)_BUILD
    cd '$(1)' && sh autogen.sh
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --libs`
endef
