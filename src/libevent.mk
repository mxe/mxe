# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libevent
$(PKG)_WEBSITE  := http://libevent.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.21
$(PKG)_CHECKSUM := 872b7cdc199ead2edd9f0d1e93b4d900e67d892c014545bd3314b3ae49505eff
$(PKG)_GH_CONF  := libevent/libevent/tags, release-, -stable
$(PKG)_DEPS     := cc openssl

define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh && OPENSSL_LIBADD=-lz ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef
