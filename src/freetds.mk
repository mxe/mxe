# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := freetds
$(PKG)_WEBSITE  := http://www.freetds.org/
$(PKG)_DESCR    := FreeTDS
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.00.108
$(PKG)_CHECKSUM := 964ea116cf7b62c66f0076fd80f9be74c90c6aed280405f0502a5bcbe65ab46b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.freetds.org/pub/$(PKG)/stable/$($(PKG)_FILE)
$(PKG)_URL_2    := https://fossies.org/linux/privat/$($(PKG)_FILE)
$(PKG)_DEPS     := cc openssl libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://ftp.freetds.org/pub/freetds/stable/' | \
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
