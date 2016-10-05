# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libgcrypt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.7.3
$(PKG)_CHECKSUM := ddac6111077d0a1612247587be238c5294dd0ee4d76dc7ba783cc55fb0337071
$(PKG)_SUBDIR   := libgcrypt-$($(PKG)_VERSION)
$(PKG)_FILE     := libgcrypt-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://mirrors.dotsrc.org/gcrypt/libgcrypt/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.gnupg.org/gcrypt/libgcrypt/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgpg_error

define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://ftp.gnupg.org/gcrypt/libgcrypt/' | \
    $(SED) -n 's,.*libgcrypt-\([0-9][^>]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_CONFIGURE
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-gpg-error-prefix='$(PREFIX)/$(TARGET)'
endef

define $(PKG)_MAKE
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    ln -sf '$(PREFIX)/$(TARGET)/bin/libgcrypt-config' '$(PREFIX)/bin/$(TARGET)-libgcrypt-config'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libgcrypt.exe' \
        `$(TARGET)-libgcrypt-config --cflags --libs`
endef

define $(PKG)_BUILD
    $($(PKG)_CONFIGURE)
    $($(PKG)_MAKE)
endef

define $(PKG)_BUILD_x86_64-w64-mingw32
    cd '$(1)' && autoreconf -fi
    $($(PKG)_CONFIGURE) \
        ac_cv_sys_symbol_underscore=no \
        --disable-padlock-support
    $($(PKG)_MAKE)
endef
