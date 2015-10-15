# This file is part of MXE.
# See index.html for further information.

PKG             := mingw-w64
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0.4
$(PKG)_CHECKSUM := 89356a0aa8cf9f8b9dc8d92bc8dd01a131d4750c3acb30c6350a406316c42199
$(PKG)_SUBDIR   := $(PKG)-v$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-v$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(PKG)-release/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/' | \
    $(SED) -n 's,.*mingw-w64-v\([0-9.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD_mingw-w64
    mkdir '$(1).headers-build'
    cd '$(1).headers-build' && '$(1)/mingw-w64-headers/configure' \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-sdk=all \
        --enable-idl
    $(MAKE) -C '$(1).headers-build' install
endef

$(PKG)_BUILD_x86_64-w64-mingw32 = $($(PKG)_BUILD_mingw-w64)
$(PKG)_BUILD_i686-w64-mingw32   = $($(PKG)_BUILD_mingw-w64)
