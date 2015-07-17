# This file is part of MXE.
# See index.html for further information.

PKG             := openldap
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.41
$(PKG)_CHECKSUM := 8a8813b2173b374cb64260245d7094fa81176854
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := ftp://ftp.openldap.org/pub/OpenLDAP/$(PKG)-release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgcrypt gnutls libgsasl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.openldap.org/software/download/' | \
    grep 'openldap-release' | \
    $(SED) -n 's,.*openldap-\([0-9][^>]*\)\.tgz.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef
