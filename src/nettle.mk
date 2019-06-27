# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := nettle
$(PKG)_WEBSITE  := https://www.lysator.liu.se/~nisse/nettle/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.5.1
$(PKG)_CHECKSUM := 75cca1998761b02e16f2db56da52992aef622bf55a3b45ec538bc2eedadc9419
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.lysator.liu.se/~nisse/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gmp

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.lysator.liu.se/~nisse/archive/' | \
    $(SED) -n 's,.*nettle-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'pre' | \
    grep -v 'rc' | \
    sort | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(if $(BUILD_STATIC),getopt.o getopt1.o,) SUBDIRS=
    $(MAKE) -C '$(1)' -j '$(JOBS)' install SUBDIRS=
endef
