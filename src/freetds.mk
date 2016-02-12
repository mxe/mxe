# This file is part of MXE.
# See index.html for further information.

PKG             := freetds
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.95.84
$(PKG)_CHECKSUM := 9c4de7f4e8dce0a7606004bb3b8d77b032efba2b583907af540492e222cc54ca
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
