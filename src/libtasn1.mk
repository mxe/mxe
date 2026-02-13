# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libtasn1
$(PKG)_WEBSITE  := https://www.gnu.org/software/libtasn1/
$(PKG)_DESCR    := GnuTLS
$(PKG)_VERSION  := 4.21.0
$(PKG)_CHECKSUM := 1d8a444a223cc5464240777346e125de51d8e6abf0b8bac742ac84609167dc87
$(PKG)_SUBDIR   := libtasn1-$($(PKG)_VERSION)
$(PKG)_FILE     := libtasn1-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/libtasn1/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- https://ftp.gnu.org/gnu/libtasn1/ | \
    $(SED) -n 's,.*libtasn1-\([1-9]\+\(\.[0-9]\+\)\+\).*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
