# This file is part of MXE.
# See index.html for further information.

PKG             := mman-win32
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 378ed6b69bb7220511dd9cd0973c22b3f6773ce7
$(PKG)_CHECKSUM := f2e54393f530b35d1736fa98a5a29d7d3a0ce76b
$(PKG)_SUBDIR   := mman-win32-master
$(PKG)_FILE     := mman-win32-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/witwall/mman-win32/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc

$(PKG)_UPDATE = $(call MXE_GET_GITHUB_SHA, witwall/mman-win32, master)

define $(PKG)_BUILD
    cd '$(1)' && chmod +x configure
    cd '$(1)' && ./configure \
        --cross-prefix='$(TARGET)'- \
        $(if $(BUILD_STATIC),--enable-static ) \
        --prefix='$(PREFIX)/$(TARGET)' \
        --libdir='$(PREFIX)/$(TARGET)/lib' \
        --incdir='$(PREFIX)/$(TARGET)/include/sys'
    $(MAKE) -C '$(1)' -j 1
    $(MAKE) -C '$(1)' -j 1 install
endef
