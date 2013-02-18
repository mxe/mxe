# This file is part of MXE.
# See index.html for further information.

PKG             := sqlite
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 075732562183d560cd46a0d8d08b50bc44e34eac
$(PKG)_SUBDIR   := $(PKG)-autoconf-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-autoconf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.sqlite.org/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.sqlite.org/download.html' | \
    $(SED) -n 's,.*sqlite-autoconf-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-readline \
        --disable-threadsafe
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
