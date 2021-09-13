# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := db48
$(PKG)_WEBSITE  := https://www.oracle.com/technetwork/database/database-technologies/berkeleydb/overview/index.html
$(PKG)_DESCR    := Oracle Berkeley DB v4.8.30
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.8.30
$(PKG)_CHECKSUM := e0491a07cdb21fb9aa82773bbbedaeb7639cbd0e7f96147ab46141e0045db72a
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
