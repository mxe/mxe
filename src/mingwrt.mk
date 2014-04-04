# This file is part of MXE.
# See index.html for further information.

PKG             := mingwrt
$(PKG)_VERSION  := 4.0.3
$(PKG)_CHECKSUM := fb78aca24b9b5ec9c43a8e0f23c0d251ba9b2b14
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-1-mingw32-dev.tar.lzma
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mingw/MinGW/Base/mingw-rt/mingwrt-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/mingw/files/MinGW/Base/mingw-rt/' | \
    $(SED) -n 's,.*mingwrt-\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD_i686-pc-mingw32
    $(INSTALL) -d '$(PREFIX)/$(TARGET)'
    cd '$(1)' && \
        cp -rpv include lib '$(PREFIX)/$(TARGET)'
endef
