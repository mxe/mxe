# This file is part of MXE.
# See index.html for further information.

PKG             := plibc
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := b545c602dc5b381fcea9d096910dede95168fbeb
$(PKG)_SUBDIR   := PlibC-$($(PKG)_VERSION)
$(PKG)_FILE     := plibc-$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/plibc/files/plibc/$($(PKG)_VERSION)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- "http://sourceforge.net/projects/plibc/files/plibc/" | \
    grep 'plibc/files/plibc' | \
    $(SED) -n 's,.*plibc/\([0-9][^>]*\)/.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    chmod 0755 '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --includedir='$(PREFIX)/$(TARGET)/include/plibc' \
        --enable-static \
        --disable-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
