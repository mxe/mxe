# This file is part of MXE.
# See index.html for further information.

PKG             := libaacs
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.7.1
$(PKG)_CHECKSUM := ecc49a22ae2a645cfb5b8e732b51fe0e2684e6488a68debc5edd6e07edadb2b0
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.bz2
$(PKG)_URL      := http://ftp.videolan.org/pub/videolan/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.videolan.org/pub/videolan/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgcrypt libgpg_error

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.videolan.org/pub/videolan/libaacs/' | \
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
        '$(2).c' \
        -o '$(PREFIX)/$(TARGET)/bin/test-libaacs.exe' \
        `'$(TARGET)-pkg-config' libaacs --cflags --libs`
endef
