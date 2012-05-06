# This file is part of MXE.
# See index.html for further information.

PKG             := mingwrt
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 7c63f3695968054b7236282f35562bb3a2c388d4
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-mingw32-dev.tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mingw/MinGW/Base/mingw-rt/$(PKG)-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/mingw/files/MinGW/Base/mingw-rt/' | \
    $(SED) -n 's,.*mingwrt-\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(INSTALL) -d '$(PREFIX)/$(TARGET)'
    cd '$(1)' && \
        cp -rpv include lib '$(PREFIX)/$(TARGET)'
endef

$(PKG)_BUILD_i686-static-mingw32    = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-static-mingw32  =
$(PKG)_BUILD_i686-dynamic-mingw32   = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-dynamic-mingw32 =
