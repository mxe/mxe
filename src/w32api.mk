# This file is part of MXE.
# See index.html for further information.

PKG             := w32api
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 1eb60b0cd546bf3efdc3fb89a4118df11da2314a
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-2-mingw32-dev.tar.lzma
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mingw/MinGW/Base/$(PKG)/$(PKG)-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/mingw/files/MinGW/Base/w32api/' | \
    $(SED) -n 's,.*w32api-\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD_i686-static-mingw32
    $(INSTALL) -d '$(PREFIX)/$(TARGET)'
    cp -rpv '$(1)/include' '$(1)/lib' '$(PREFIX)/$(TARGET)'
endef
