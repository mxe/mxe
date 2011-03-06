# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# MinGW Windows API
PKG             := w32api
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.16
$(PKG)_CHECKSUM := 5b6c1503efc44791fad72512febeed943e4ce393
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-1-mingw32-dev.tar.lzma
$(PKG)_WEBSITE  := http://www.mingw.org/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mingw/MinGW/BaseSystem/RuntimeLibrary/Win32-API/$(PKG)-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/mingw/files/MinGW/BaseSystem/RuntimeLibrary/Win32-API/' | \
    $(SED) -n 's,.*w32api-\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(INSTALL) -d '$(PREFIX)/$(TARGET)'
    cp -rpv '$(1)/include' '$(1)/lib' '$(PREFIX)/$(TARGET)'
endef
