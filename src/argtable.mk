# This file is part of MXE.
# See index.html for further information.

PKG             := argtable
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := bce828c64c35e16f4c3f8e1f355e4a2a97fe3289
$(PKG)_SUBDIR   := argtable$(subst .,-,$($(PKG)_VERSION))
$(PKG)_FILE     := argtable$(subst .,-,$($(PKG)_VERSION)).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/argtable/argtable/argtable-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/argtable/files/argtable/' | \
    $(SED) -n 's,.*argtable-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-debug
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
