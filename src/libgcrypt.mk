# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libgcrypt
PKG             := libgcrypt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5.0
$(PKG)_CHECKSUM := 3e776d44375dc1a710560b98ae8437d5da6e32cf
$(PKG)_SUBDIR   := libgcrypt-$($(PKG)_VERSION)
$(PKG)_FILE     := libgcrypt-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := ftp://ftp.gnupg.org/gcrypt/libgcrypt/
$(PKG)_URL      := ftp://ftp.gnupg.org/gcrypt/libgcrypt/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgpg_error

define $(PKG)_UPDATE
    wget -q -O- 'ftp://ftp.gnupg.org/gcrypt/libgcrypt/' | \
    $(SED) -n 's,.*libgcrypt-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v '^1\.4\.' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-gpg-error-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
