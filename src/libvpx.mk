# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# vpx
PKG             := libvpx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.1
$(PKG)_CHECKSUM := a18acb7a1a2fd62268e63aab860b43ff04669b9e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://code.google.com/p/webm/
$(PKG)_URL      := http://webm.googlecode.com/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://code.google.com/p/webm/downloads/list?sort=-uploaded' | \
    $(SED) -n 's,.*libvpx-\([0-9][^<]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && \
	NM="i686-pc-mingw32-nm" \
	STRIP="i686-pc-mingw32-strip" \
	CC="i686-pc-mingw32-gcc" \
	./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
	--target=x86-win32-gcc \
	--disable-examples
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    $(TARGET)-ranlib $(PREFIX)/$(TARGET)/lib/libvpx.a
endef
