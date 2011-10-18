# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# x264
PKG             := x264
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 20111018-2245
$(PKG)_CHECKSUM := a6c4a6786a2347b5b1d50dc0ddfd378bf1890481
$(PKG)_SUBDIR   := $(PKG)-snapshot-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-snapshot-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.videolan.org/developers/x264.html
$(PKG)_URL      := http://download.videolan.org/pub/videolan/$(PKG)/snapshots/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    date -d yesterday +%Y%m%d-2245
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --cross-prefix='$(TARGET)'- \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --enable-static \
        --enable-win32thread
    $(MAKE) -C '$(1)' -j 1 uninstall
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
