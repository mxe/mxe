# This file is part of MXE.
# See index.html for further information.

PKG             := libdvbpsi
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := b918985f65e1d14bf19209b6b3def254c902901a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.bz2
$(PKG)_URL      := http://download.videolan.org/pub/libdvbpsi/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.videolan.org/developers/libdvbpsi.html' | \
    $(SED) -n 's,.*http://www.videolan.org/pub/libdvbpsi/\([0-9][^<]*\)/.*,\1,p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-release
    $(MAKE) -C '$(1)' -j '$(JOBS)' SUBDIRS=src
    $(MAKE) -C '$(1)' -j 1 install SUBDIRS=src
endef
