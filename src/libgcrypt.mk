# libgcrypt
# ftp://ftp.gnupg.org/gcrypt/libgcrypt/

PKG            := libgcrypt
$(PKG)_VERSION := 1.4.0
$(PKG)_SUBDIR  := libgcrypt-$($(PKG)_VERSION)
$(PKG)_FILE    := libgcrypt-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL     := ftp://ftp.gnupg.org/gcrypt/libgcrypt/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc libgpg_error

define $(PKG)_UPDATE
    wget -q -O- 'ftp://ftp.gnupg.org/gcrypt/libgcrypt/' | \
    $(SED) -n 's,.*libgcrypt-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) '26i\#include <ws2tcpip.h>' -i '$(1)/src/gcrypt.h.in'
    $(SED) '26i\#include <ws2tcpip.h>' -i '$(1)/src/ath.h'
    $(SED) 's,sys/times.h,sys/time.h,' -i '$(1)/cipher/random.c'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) 's,cross_compiling=no,cross_compiling=yes,' -i '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-gpg-error-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
