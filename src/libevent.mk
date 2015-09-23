# This file is part of MXE.
# See index.html for further information.

PKG             := libevent
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.21
$(PKG)_CHECKSUM := 872b7cdc199ead2edd9f0d1e93b4d900e67d892c014545bd3314b3ae49505eff
$(PKG)_SUBDIR   := libevent-release-$($(PKG)_VERSION)-stable
$(PKG)_FILE     := release-$($(PKG)_VERSION)-stable.tar.gz
$(PKG)_URL      := https://github.com/$(PKG)/$(PKG)/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc openssl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://libevent.org/' | \
    grep 'libevent-' | \
    $(SED) -n 's,.*libevent-\([0-9][^>]*\)-stable\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh && OPENSSL_LIBADD=-lz ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef
