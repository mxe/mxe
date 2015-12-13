# This file is part of MXE.
# See index.html for further information.

PKG             := freetds
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.95.75
$(PKG)_CHECKSUM := 23cbac96805730f7760256631561f65f88aab3cd4b6d1f5dae53721c79a02f81
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.freetds.org/pub/$(PKG)/stable/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gnutls libiconv

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
        --with-gnutls \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install man_MANS=
endef
