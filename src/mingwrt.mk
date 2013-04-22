# This file is part of MXE.
# See index.html for further information.

PKG             := mingwrt
$(PKG)_IGNORE   := 4.0
$(PKG)_CHECKSUM := cc6c1f841ab255e52e60f9c967cea6acf29354db
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-mingw32-dev.tar.lzma
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mingw/MinGW/Base/mingw-rt/mingwrt-3.20/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/mingw/files/MinGW/Base/mingw-rt/' | \
    $(SED) -n 's,.*mingwrt-\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(INSTALL) -d '$(PREFIX)/$(TARGET)'
    cd '$(1)' && \
        cp -rpv include lib '$(PREFIX)/$(TARGET)'
endef
