# This file is part of MXE.
# See index.html for further information.

PKG             := mpfr
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 9ba6dfe62dad298f0570daf182db31660f7f016c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := http://www.mpfr.org/mpfr-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gmp

define $(PKG)_UPDATE
    wget -q -O- 'http://www.mpfr.org/mpfr-current/#download' | \
    grep 'mpfr-' | \
    $(SED) -n 's,.*mpfr-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        $(LINK_STYLE) \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-threads=win32 \
        --with-gmp-include='$(PREFIX)/$(TARGET)/include/'
        --with-gmp-lib='$(PREFIX)/$(TARGET)/lib/'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
