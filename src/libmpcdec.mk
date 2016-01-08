# This file is part of MXE.
# See index.html for further information.

PKG             := libmpcdec
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.6
$(PKG)_CHECKSUM := 4bd54929a80850754f27b568d7891e1e3e1b8d2f208d371f27d1fda09e6f12a8
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://files.musepack.net/source/$(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://files.musepack.net/source/$(PKG)-$($(PKG)_VERSION)' | \
    $(SED) -n 's,.*$(PKG)-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'alpha' | \
    grep -v 'beta' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j 1 install
endef
