# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# x264
PKG             := x264
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 20110422-2245
$(PKG)_CHECKSUM := 8d5d4463a8070917b7fd48c3283ed72774a60cc2
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
        --enable-win32thread
    $(MAKE) -C '$(1)' -j 1 uninstall
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
