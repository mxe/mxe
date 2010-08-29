# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# MinGW Windows API
PKG             := w32api
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.15-1
$(PKG)_CHECKSUM := a1f8f3767970663b3394e37919c0a4ea029473d6
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := w32api-$($(PKG)_VERSION)-mingw32-dev.tar.lzma
$(PKG)_WEBSITE  := http://mingw.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mingw/MinGW/BaseSystem/RuntimeLibrary/Win32-API/w32api-3.15/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/mingw/files/MinGW/BaseSystem/RuntimeLibrary/Win32-API/) | \
    $(SED) -n 's,.*w32api-\([0-9][^>]*\)-mingw32-dev\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    $(INSTALL) -d '$(PREFIX)/$(TARGET)'
    cp -rpv '$(1)/include' '$(1)/lib' '$(PREFIX)/$(TARGET)'
endef
