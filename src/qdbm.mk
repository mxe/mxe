# This file is part of MXE.
# See index.html for further information.

PKG             := qdbm
VERSION         := 1.8.78
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 8c2ab938c2dad8067c29b0aa93efc6389f0e7076
$(PKG)_SUBDIR   := qdbm-$($(PKG)_VERSION)
$(PKG)_FILE     := qdbm-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://fallabs.com/qdbm/qdbm-1.8.78.tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://fallabs.com/qdbm/' | \
    grep 'qdbm-' | \
    $(SED) -n 's,.*qdbm-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)/' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        CONFIG_SHELL=$(SHELL)
    $(MAKE) -C '$(1)/' -j '$(JOBS)' install
endef
