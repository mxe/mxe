PKG             := db
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.8.30
$(PKG)_CHECKSUM := ab36c170dda5b2ceaad3915ced96e41c6b7e493c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.oracle.com/berkeley-db/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- http://www.oracle.com/technetwork/database/berkeleydb/downloads/index-082944.html | \
    grep -P '(?<=href..)http.*db-4.8.*(?=\"\>)' -o | \
    head -1 | \
    $(SED) -n 's,.*db-\([0-9][^>]*\)\.tar.*,\1,p'
endef


define $(PKG)_BUILD
    cd '$(1)/build_unix' && ../dist/configure --target='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' && \
    $(MAKE) -j '$(JOBS)' && \
    $(MAKE) install
endef

