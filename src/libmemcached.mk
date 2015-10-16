# This file is part of MXE.
# See index.html for further information.

PKG             := libmemcached
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.18
$(PKG)_CHECKSUM := e22c0bb032fde08f53de9ffbc5a128233041d9f33b5de022c0978a2149885f82
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://launchpad.net/$(PKG)/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_VERSION)/+download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libevent pthreads libmysqlclient

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://launchpad.net/libmemcached/+download' | \
    $(SED) -n 's,.*libmemcached-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-mysql='$(PREFIX)/$(TARGET)/bin/mysql_config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' \
        LDFLAGS="-no-undefined"
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS=
    cp '$(1)/support/libmemcached.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'
endef
