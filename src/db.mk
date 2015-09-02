# This file is part of MXE.
# See index.html for further information.

PKG             := db
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.8.30
$(PKG)_CHECKSUM := ab36c170dda5b2ceaad3915ced96e41c6b7e493c
$(PKG)_SUBDIR   := db-$($(PKG)_VERSION)
$(PKG)_FILE     := db-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.oracle.com/berkeley-db/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'TODO: Updates for package db need to be fixed.' >&2;
    echo $(db_VERSION)
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

$(PKG)_BUILD_SHARED =
