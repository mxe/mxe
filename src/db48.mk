# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := db48
$(PKG)_WEBSITE  := https://www.oracle.com/technetwork/database/database-technologies/berkeleydb/overview/index.html
$(PKG)_DESCR    := Oracle Berkeley DB v4.8.30
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.8.30.NC
$(PKG)_CHECKSUM := 12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef
$(PKG)_SUBDIR   := db-$($(PKG)_VERSION)
$(PKG)_FILE     := db-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://download.oracle.com/berkeley-db/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

#define $(PKG)_UPDATE
#    $(WGET) -q -O- 'https://www.oracle.com/technetwork/database/database-technologies/berkeleydb/downloads/index.html' | \
#    $(SED) -n 's,.*/db-\([0-9\.]\+\)\.tar.gz.*,\1,p' | \
#    head -1
#endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/dist/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --enable-mingw \
        --enable-cxx \
        --enable-cryptography \
        --disable-replication \
        --with-mutex=$(subst i686,x86,$(PROCESSOR))/gcc-assembly \
        $(PKG_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' UTIL_PROGS=
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install_include install_lib
endef
