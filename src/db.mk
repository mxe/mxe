# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := db
$(PKG)_WEBSITE  := https://www.oracle.com/technetwork/database/database-technologies/berkeleydb/overview/index.html
$(PKG)_DESCR    := Oracle Berkeley DB
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.2.32
$(PKG)_CHECKSUM := a9c5e2b004a5777aa03510cfe5cd766a4a3b777713406b02809c17c8e0e7a8fb
$(PKG)_SUBDIR   := db-$($(PKG)_VERSION)
$(PKG)_FILE     := db-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.oracle.com/berkeley-db/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.oracle.com/technetwork/database/database-technologies/berkeleydb/downloads/index.html' | \
    $(SED) -n 's,.*/db-\([0-9\.]\+\)\.tar.gz.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)/build_unix' && ../dist/configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-mingw \
        --enable-cxx \
        --enable-cryptography \
        --disable-replication

    $(MAKE) -C '$(1)/build_unix' -j '$(JOBS)'
    $(MAKE) -C '$(1)/build_unix' -j 1 install $(MXE_DISABLE_DOCS)
endef
