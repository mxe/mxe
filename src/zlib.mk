# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# zlib
PKG             := zlib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.6
$(PKG)_CHECKSUM := 3d445731e4bfea1cd00f36567d77d6e5f5a19be9
$(PKG)_SUBDIR   := zlib-$($(PKG)_VERSION)
$(PKG)_FILE     := zlib-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://zlib.net/
$(PKG)_URL      := http://zlib.net/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://zlib.net/' | \
    $(SED) -n 's,.*zlib-\([0-9][^>]*\)\.tar.*,\1,ip' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CHOST='$(TARGET)' ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --static
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
