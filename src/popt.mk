# This file is part of MXE.
# See index.html for further information.

PKG             := popt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.16
$(PKG)_CHECKSUM := cfe94a15a2404db85858a81ff8de27c8ff3e235e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://rpm5.org/files/popt/$($(PKG)_FILE)
$(PKG)_URL_2    := http://ftp.debian.org/debian/pool/main/p/$(PKG)/$(PKG)_$($(PKG)_VERSION).orig.tar.gz
$(PKG)_DEPS     := gcc libiconv gettext

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://rpm5.org/files/popt/' | \
    grep 'popt-' | \
    $(SED) -n 's,.*popt-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-nls
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
