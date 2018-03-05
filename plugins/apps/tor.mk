# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := tor
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.3.0.7
$(PKG)_CHECKSUM := 9640c4448ef3cad7237c68ed6984e705db8fb2b9d6bb74c8815d01bb06527d02
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://torproject.org/dist/$($(PKG)_FILE)
$(PKG)_WEBSITE  := https://torproject.org/
$(PKG)_OWNER    := https://github.com/starius
$(PKG)_DEPS     := cc libevent openssl zlib

define $(PKG)_UPDATE
$(WGET) -q -O- 'https://torproject.org/download/download' | \
    $(SED) -n 's,.*tor-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && \
        LIBS="`'$(TARGET)-pkg-config' --libs-only-l openssl`" \
        '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(SED) 's@#define HAVE_SYS_MMAN_H 1@// Disabled in MXE #define HAVE_SYS_MMAN_H 1@' -i '$(BUILD_DIR)/orconfig.h'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_DOCS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_DOCS)
endef
