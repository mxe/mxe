# This file is part of MXE.
# See index.html for further information.

PKG             := tor
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.6.10
$(PKG)_CHECKSUM := 4bf9689b311efce70db96c88d1f466caa41e0277
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://torproject.org/dist/$($(PKG)_FILE)
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
