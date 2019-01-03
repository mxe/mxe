# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := wget
$(PKG)_WEBSITE  := https://www.gnu.org/software/wget/
$(PKG)_VERSION  := 1.20.1
$(PKG)_CHECKSUM := b783b390cb571c837b392857945f5a1f00ec6b043177cc42abb8ee1b542ee1b3
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gnutls libidn2 libntlm pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.savannah.gnu.org/cgit/wget.git/refs/' | \
    $(SED) -n "s,.*<a href='/cgit/wget.git/tag/?h=v\([0-9.]*\)'>.*,\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-ssl=gnutls \
        CFLAGS='-DIN6_ARE_ADDR_EQUAL=IN6_ADDR_EQUAL $(if $(BUILD_STATIC),-DGNUTLS_INTERNAL_BUILD,)'
    $(MAKE) -C '$(1)/lib' -j '$(JOBS)'
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' install-binPROGRAMS
endef
