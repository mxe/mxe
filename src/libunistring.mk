# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libunistring
$(PKG)_WEBSITE  := https://www.gnu.org/software/libunistring/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.10
$(PKG)_CHECKSUM := a82e5b333339a88ea4608e4635479a1cfb2e01aafb925e1290b65710d43f610b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.savannah.gnu.org/gitweb/?p=libunistring.git;a=tags' | \
    grep '<a class="list name"' | \
    $(SED) -n 's,.*<a[^>]*>v\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads=win32
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
