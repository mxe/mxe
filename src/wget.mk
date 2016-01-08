# This file is part of MXE.
# See index.html for further information.

PKG             := wget
$(PKG)_VERSION  := 1.16.3
$(PKG)_CHECKSUM := 67f7b7b0f5c14db633e3b18f53172786c001e153d545cfc85d82759c5c2ffb37
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gnutls libidn libntlm pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.savannah.gnu.org/cgit/wget.git/refs/' | \
    $(SED) -n "s,.*<a href='/cgit/wget.git/tag/?id=v\([0-9.]*\)'>.*,\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    # avoid conflict with base64_encode from gnutls
    $(if $(BUILD_STATIC), $(SED) -i 's/^base64_encode /wget_base64_encode /;' '$(1)/src/utils.c')
    $(SED) -i 's/-lidn/`$(TARGET)-pkg-config --libs libidn`/g;' '$(1)/configure'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-ssl=gnutls \
        CFLAGS='-DIN6_ARE_ADDR_EQUAL=IN6_ADDR_EQUAL' \
        LIBS='-lpthread'
    $(MAKE) -C '$(1)/lib' -j '$(JOBS)'
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' install-binPROGRAMS
endef
