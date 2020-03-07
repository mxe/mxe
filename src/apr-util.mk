# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := apr-util
$(PKG)_WEBSITE  := https://apr.apache.org/
$(PKG)_DESCR    := APR-util
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5.4
$(PKG)_CHECKSUM := 976a12a59bc286d634a21d7be0841cc74289ea9077aa1af46be19d1a6e844c19
$(PKG)_SUBDIR   := apr-util-$($(PKG)_VERSION)
$(PKG)_FILE     := apr-util-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://archive.apache.org/dist/apr/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.apache.org/dist/apr/$($(PKG)_FILE)
$(PKG)_DEPS     := cc apr expat libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://apr.apache.org/download.cgi' | \
    grep 'aprutil1.*best' |
    $(SED) -n 's,.*APR-util \([0-9.]*\).*,\1,p'
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --without-pgsql \
        --without-sqlite2 \
        --without-sqlite3 \
        --without-freetds \
        --with-apr='$(PREFIX)/$(TARGET)' \
        CFLAGS=-D_WIN32_WINNT=0x0500
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT) LDFLAGS=-no-undefined
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_CRUFT)
    $(if $(BUILD_STATIC), \
        $(SED) -i '1i #define APU_DECLARE_STATIC 1' \
            '$(PREFIX)/$(TARGET)/include/apr-1/apu.h')
    ln -sf '$(PREFIX)/$(TARGET)/bin/apu-1-config' '$(PREFIX)/bin/$(TARGET)-apu-1-config'
endef
