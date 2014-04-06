# This file is part of MXE.
# See index.html for further information.

PKG             := wget
$(PKG)_VERSION  := 1.15
$(PKG)_CHECKSUM := e9fb1d25fa04f9c69e74e656a3174dca02700ba1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pthreads gnutls libntlm libidn

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.savannah.gnu.org/cgit/wget.git/refs/' | \
    $(SED) -n "s,.*<a href='/cgit/wget.git/tag/?id=v\([0-9.]*\)'>.*,\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    # avoid conflict with base64_encode from gnutls
    $(SED) -i 's/^base64_encode /wget_base64_encode /;' '$(1)/src/utils.c'
    $(SED) -i 's/-lidn/`$(TARGET)-pkg-config --libs libidn`/g;' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-ssl=gnutls \
        CFLAGS='-DIN6_ARE_ADDR_EQUAL=IN6_ADDR_EQUAL' \
        LIBS='-lpthread'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef

$(PKG)_BUILD_SHARED =
