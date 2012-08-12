# This file is part of MXE.
# See index.html for further information.

PKG             := mpg123
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 9f53e27bb40b8df3d3b6df25f5f9a8a83b1fccfe
$(PKG)_SUBDIR   := mpg123-$($(PKG)_VERSION)
$(PKG)_FILE     := mpg123-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mpg123/mpg123/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/mpg123/files/mpg123/' | \
    $(SED) -n 's,.*mpg123-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
#    cd '$(1)' && ./autogen.sh
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-debug
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
