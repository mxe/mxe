# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# MinGW Runtime
PKG             := mingwrt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.18
$(PKG)_CHECKSUM := 0c562f3b6a89f376b9edba48ccd7388c535f8c8d
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-mingw32-dev.tar.gz
$(PKG)_WEBSITE  := http://mingw.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mingw/MinGW/BaseSystem/RuntimeLibrary/MinGW-RT/$(PKG)-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/mingw/files/MinGW/BaseSystem/RuntimeLibrary/MinGW-RT/' | \
    $(SED) -n 's,.*mingwrt-\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(INSTALL) -d '$(PREFIX)/$(TARGET)'
    cd '$(1)' && \
        cp -rpv include lib '$(PREFIX)/$(TARGET)'
endef
