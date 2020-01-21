# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libevent
$(PKG)_WEBSITE  := https://libevent.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.11
$(PKG)_CHECKSUM := 229393ab2bf0dc94694f21836846b424f3532585bac3468738b7bf752c03901e
$(PKG)_GH_CONF  := libevent/libevent/tags, release-, -stable
$(PKG)_DEPS     := cc openssl

define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh && OPENSSL_LIBADD=-lz ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef
