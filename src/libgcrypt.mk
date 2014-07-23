# This file is part of MXE.
# See index.html for further information.

PKG             := libgcrypt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5.3
$(PKG)_CHECKSUM := 2c6553cc17f2a1616d512d6870fe95edf6b0e26e
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
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libgcrypt.exe' \
        `$(TARGET)-libgcrypt-config --cflags --libs`
endef

define $(PKG)_BUILD
    $($(PKG)_CONFIGURE)
    $($(PKG)_MAKE)
endef

define $(PKG)_BUILD_x86_64-w64-mingw32
    $($(PKG)_CONFIGURE) \
        ac_cv_sys_symbol_underscore=no
    $($(PKG)_MAKE)
endef
