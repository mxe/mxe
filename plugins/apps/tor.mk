# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := tor
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.9.8
$(PKG)_CHECKSUM := fbdd33d3384574297b88744622382008d1e0f9ddd300d330746c464b7a7d746a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://torproject.org/dist/$($(PKG)_FILE)
$(PKG)_WEBSITE  := https://torproject.org/
$(PKG)_OWNER    := https://github.com/starius
$(PKG)_DEPS     := gcc libevent openssl zlib

define $(PKG)_UPDATE
$(WGET) -q -O- 'https://torproject.org/download/download' | \
    $(SED) -n 's,.*tor-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && \
        LIBS="`'$(TARGET)-pkg-config' --libs-only-l openssl`" \
        ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_DOCS)
endef

$(PKG)_BUILD_SHARED =
