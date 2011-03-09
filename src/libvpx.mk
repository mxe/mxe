# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# vpx
PKG             := libvpx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.6
$(PKG)_CHECKSUM := a3522bd2b73d52381ba767ded1cbf4760e9cc6f8
$(PKG)_SUBDIR   := $(PKG)-v$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-v$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://code.google.com/p/webm/
$(PKG)_URL      := http://webm.googlecode.com/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://code.google.com/p/webm/downloads/list?sort=-uploaded' | \
    $(SED) -n 's,.*libvpx-v\([0-9][^<]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && \
        CROSS='$(TARGET)-' \
        ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --target=x86-win32-gcc \
        --disable-examples \
        --disable-install-docs
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    $(TARGET)-ranlib $(PREFIX)/$(TARGET)/lib/libvpx.a
endef
