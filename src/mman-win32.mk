# This file is part of MXE.
# See index.html for further information.

PKG             := mman-win32
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 3421c28e753c38d24a2e27c111b1c9b4601ebe7d
$(PKG)_CHECKSUM := c33e84043d49d0e33bc434bda3a16ce60432e789
$(PKG)_SUBDIR   := mman-win32-master
$(PKG)_FILE     := master.tar.gz
$(PKG)_URL      := https://github.com/witwall/mman-win32/archive/master.tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && chmod +x configure
    cd '$(1)' && ./configure \
        --cross-prefix='$(TARGET)'- \
        --enable-static \
        --prefix='$(PREFIX)/$(TARGET)' \
        --libdir='$(PREFIX)/$(TARGET)/lib' \
        --incdir='$(PREFIX)/$(TARGET)/include/sys'
    $(MAKE) -C '$(1)' -j 1
    $(MAKE) -C '$(1)' -j 1 install
endef


