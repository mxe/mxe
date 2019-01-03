# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libevent
$(PKG)_WEBSITE  := https://libevent.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.8
$(PKG)_CHECKSUM := 316ddb401745ac5d222d7c529ef1eada12f58f6376a66c1118eee803cb70f83d
$(PKG)_GH_CONF  := libevent/libevent/tags, release-, -stable
$(PKG)_DEPS     := cc openssl

define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh && OPENSSL_LIBADD=-lz ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef
