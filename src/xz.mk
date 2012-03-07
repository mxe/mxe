# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# XZ
PKG             := xz
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.0.3
$(PKG)_CHECKSUM := 50ce842bea6519537457d9ad90d110a127656786
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://tukaani.org/xz/
$(PKG)_URL      := http://tukaani.org/xz/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://tukaani.org/xz/' | \
    $(SED) -n 's,.*xz-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-dynamic \
        --disable-threads \
        --disable-nls
    $(MAKE) -C '$(1)'/src/liblzma -j '$(JOBS)' install
endef
