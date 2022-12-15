# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xz
$(PKG)_WEBSITE  := https://tukaani.org/xz/
$(PKG)_DESCR    := XZ
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.4.0
$(PKG)_CHECKSUM := 7471ef5991f690268a8f2be019acec2e0564b7b233ca40035f339fe9a07f830b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://tukaani.org/xz/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://tukaani.org/xz/' | \
    $(SED) -n 's,.*xz-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-threads \
        --disable-nls
    $(MAKE) -C '$(1)'/src/liblzma -j '$(JOBS)' install
endef
