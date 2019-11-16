# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libtasn1
$(PKG)_WEBSITE  := https://www.gnu.org/software/libtasn1/
$(PKG)_DESCR    := GnuTLS
$(PKG)_VERSION  := 4.14
$(PKG)_CHECKSUM := 9e604ba5c5c8ea403487695c2e407405820d98540d9de884d6e844f9a9c5ba08
$(PKG)_SUBDIR   := libtasn1-$($(PKG)_VERSION)
$(PKG)_FILE     := libtasn1-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/libtasn1/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- https://ftp.gnu.org/gnu/libtasn1/ | \
    $(SED) -n 's,.*libtasn1-\([1-9]\+\.[0-9]\+\)\..*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
