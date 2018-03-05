# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := liboauth
$(PKG)_WEBSITE  := https://liboauth.sourceforge.io/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.3
$(PKG)_CHECKSUM := 0df60157b052f0e774ade8a8bac59d6e8d4b464058cc55f9208d72e41156811f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc curl openssl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/liboauth/files/' | \
    $(SED) -n 's,.*liboauth-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-curl
    $(MAKE) -C '$(1)' -j '$(JOBS)' LDFLAGS='-no-undefined'
    $(MAKE) -C '$(1)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-liboauth.exe' \
        `'$(TARGET)-pkg-config' oauth --cflags --libs`
endef
