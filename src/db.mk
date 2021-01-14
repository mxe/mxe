# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := db
$(PKG)_WEBSITE  := https://www.oracle.com/technetwork/database/database-technologies/berkeleydb/overview/index.html
$(PKG)_DESCR    := Oracle Berkeley DB
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 18.1.40
$(PKG)_CHECKSUM := 0cecb2ef0c67b166de93732769abdeba0555086d51de1090df325e18ee8da9c8
$(PKG)_SUBDIR   := db-$($(PKG)_VERSION)
$(PKG)_FILE     := db-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://download.oracle.com/berkeley-db/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.oracle.com/technetwork/database/database-technologies/berkeleydb/downloads/index.html' | \
    $(SED) -n 's,.*/db-\([0-9\.]\+\)\.tar.gz.*,\1,p' | \
    head -1
endef

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
