# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xxhash
$(PKG)_WEBSITE  := https://cyan4973.github.io/xxHash/
$(PKG)_DESCR    := xxHash
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.6.1
$(PKG)_CHECKSUM := a940123baa6c71b75b6c02836bae2155cd2f74f7682e1a1d6f7b889f7bc9e7f8
$(PKG)_SUBDIR   := xxHash-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/Cyan4973/xxHash/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, Cyan4973/xxHash) | \
    $(SED) 's,^v,,g'
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(TARGET)-cmake' '$(1)/cmake_unofficial'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install

    # create pkg-config files
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: xxHash'; \
     echo 'Libs: -lxxhash';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
