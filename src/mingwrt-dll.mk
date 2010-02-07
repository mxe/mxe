# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# MinGW Runtime DLL
PKG             := mingwrt-dll
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.17
$(PKG)_CHECKSUM := 3da95df7238337307b4b5af22d7d0b6ac61250ad
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := mingwrt-$($(PKG)_VERSION)-mingw32-dll.tar.gz
$(PKG)_WEBSITE  := http://mingw.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mingw/MinGW Runtime/mingwrt-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/mingw/files/MinGW Runtime/) | \
    $(SED) -n 's,.*mingwrt-\([0-9][^>]*\)-mingw32-dll\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    $(INSTALL) -d '$(PREFIX)/$(TARGET)'
    cd '$(1)' && \
        cp -rpv bin '$(PREFIX)/$(TARGET)'
endef
