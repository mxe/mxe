# This file is part of MXE.
# See index.html for further information.

PKG             := mman-win32
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 378ed6b69bb7220511dd9cd0973c22b3f6773ce7
$(PKG)_CHECKSUM := f2e54393f530b35d1736fa98a5a29d7d3a0ce76b
$(PKG)_SUBDIR   := mman-win32-master
$(PKG)_FILE     := mman-win32-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/witwall/mman-win32/archive/master.tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'TODO: Updates for package mman-win32 need to be written.' >&2;
    echo $(mman-win32_VERSION)
endef

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
