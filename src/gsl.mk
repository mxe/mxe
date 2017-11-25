# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gsl
$(PKG)_WEBSITE  := https://www.gnu.org/software/gsl/
$(PKG)_DESCR    := GSL
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3
$(PKG)_CHECKSUM := 562500b789cd599b3a4f88547a7a3280538ab2ff4939504c8b4ac4ca25feadfb
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/$(PKG)/' | \
    $(SED) -n 's,.*<a href="gsl-\([0-9.]\+\).tar.gz".*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-gsl.exe' \
        -lgsl
endef
