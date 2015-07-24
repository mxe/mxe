# This file is part of MXE.
# See index.html for further information.

PKG             := freetds
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0_95
$(PKG)_CHECKSUM := 217f57fb0a8cd4e8f105f860b763f6897aa71c5b
$(PKG)_SUBDIR   := $(PKG)-R$($(PKG)_VERSION)
$(PKG)_FILE     := R$($(PKG)_VERSION).tar.gz
$(PKG)_URL    := https://github.com/FreeTDS/freetds/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv gnutls

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/FreeTDS/freetds/releases' | \
    grep /FreeTDS/freetds/releases/tag|\
    $(SED) -n 's,.*tag/R\([0-9][^">]*\)\">,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autogen.sh && ./configure \
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
