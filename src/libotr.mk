# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libotr
$(PKG)_WEBSITE  := https://otr.cypherpunks.ca/
$(PKG)_DESCR    := Off-the-Record Messaging
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.1.1
$(PKG)_CHECKSUM := 8b3b182424251067a952fb4e6c7b95a21e644fbb27fbd5f8af2b2ed87ca419f5
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://otr.cypherpunks.ca/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libgcrypt libgpg_error libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://otr.cypherpunks.ca/' | \
    $(SED) -n 's,.*<a href="libotr-\([0-9][^>]*\)\.tar\.gz">.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && ACLOCAL_PATH='$(PREFIX)/$(TARGET)/share/aclocal' autoreconf -fi
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --with-libgcrypt-prefix='$(PREFIX)/$(TARGET)'

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' \
        $(if $(BUILD_SHARED), LDFLAGS=-no-undefined) $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
