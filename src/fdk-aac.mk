# This file is part of MXE.
# See index.html for further information.

# WARNING: Like openssl, the license of this package is not compatible with
# GPL 2+, but it is with LGPL 2.1+. See index.html#potential-legal-issues

PKG             := fdk-aac
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.3
$(PKG)_CHECKSUM := fda64beee7f3b8e04ca209efcf9354cdae9afc33
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/opencore-amr/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/opencore-amr/files/fdk-aac/' | \
    $(SED) -n 's,.*fdk-aac-\([0-9.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
