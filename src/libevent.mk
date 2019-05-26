# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libevent
$(PKG)_WEBSITE  := https://libevent.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.10
$(PKG)_CHECKSUM := 52c9db0bc5b148f146192aa517db0762b2a5b3060ccc63b2c470982ec72b9a79
$(PKG)_GH_CONF  := libevent/libevent/tags, release-, -stable
$(PKG)_DEPS     := cc openssl

define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh && OPENSSL_LIBADD=-lz ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef
