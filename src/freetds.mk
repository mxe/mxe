# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := freetds
$(PKG)_WEBSITE  := https://www.freetds.org/
$(PKG)_DESCR    := FreeTDS
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.17
$(PKG)_CHECKSUM := 7c0703f9f5ce90b2e155f3b06144229294926385ce01d76e88e157f8106995b9
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://www.freetds.org/files/stable/$($(PKG)_FILE)
$(PKG)_URL_2    := https://fossies.org/linux/privat/$($(PKG)_FILE)
$(PKG)_DEPS     := cc openssl libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- -t 2 --timeout=6 'https://www.freetds.org/files/stable/' | \
    $(SED) -n 's,.*freetds-\([0-9.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-rpath \
        --disable-dependency-tracking \
        --enable-libiconv \
        --enable-msdblib \
        --enable-sspi \
        --disable-threadsafe \
        --with-tdsver=7.2 \
        --with-openssl \
        PKG_CONFIG='$(TARGET)-pkg-config' \
        CFLAGS=-D_WIN32_WINNT=0x0600
    $(MAKE) -C '$(1)' -j '$(JOBS)' install man_MANS=
endef
