# This file is part of MXE.
# See index.html for further information.

PKG             := libepoxy
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.1
$(PKG)_CHECKSUM := 6700ddedffb827b42c72cce1e0be6fba67b678b19bf256e1b5efd3ea38cc2bb4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_GITHUB   := https://github.com/anholt/$(PKG)
$(PKG)_URL      := $($(PKG)_GITHUB)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc xorg-macros

define $(PKG)_UPDATE
    $(WGET) -q -O- '$(libepoxy_GITHUB)/releases' | \
    $(SED) -n 's,.*/archive/v\([0-9.]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi -I'$(PREFIX)/$(TARGET)/share/aclocal'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_CRUFT)
endef
