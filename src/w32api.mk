# This file is part of MXE.
# See index.html for further information.

PKG             := w32api
$(PKG)_VERSION  := 4.0.3
$(PKG)_CHECKSUM := 1cb75a35b6baf52e58facc97c56a7e22cd125887
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-1-mingw32-dev.tar.lzma
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mingw/MinGW/Base/$(PKG)/$(PKG)-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/mingw/files/MinGW/Base/w32api/' | \
    $(SED) -n 's,.*w32api-\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD_i686-pc-mingw32
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    cp -rpv '$(1)/include' '$(1)/lib' '$(PREFIX)/$(TARGET)'
endef
