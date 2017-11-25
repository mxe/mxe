# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libaacs
$(PKG)_WEBSITE  := https://www.videolan.org/developers/libaacs.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.1
$(PKG)_CHECKSUM := 95c344a02c47c9753c50a5386fdfb8313f9e4e95949a5c523a452f0bcb01bbe8
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.bz2
$(PKG)_URL      := https://download.videolan.org/pub/videolan/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := http://videolan-nyc.defaultroute.com/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libgcrypt libgpg_error

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.videolan.org/pub/videolan/libaacs/' | \
    $(SED) -n 's,<a href="\([0-9][^<]*\)/".*,\1,p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)

    $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT) LDFLAGS='-no-undefined'
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_CRUFT)

    '$(TARGET)-gcc' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(TEST_FILE)' \
        -o '$(PREFIX)/$(TARGET)/bin/test-libaacs.exe' \
        `'$(TARGET)-pkg-config' libaacs --cflags --libs`
endef
