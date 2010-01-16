# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# MinGW Windows API
PKG             := w32api
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.14
$(PKG)_CHECKSUM := f1c81109796c4c87243b074ebb5f85a5552e0219
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := w32api-$($(PKG)_VERSION)-mingw32-dev.tar.gz
$(PKG)_WEBSITE  := http://mingw.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mingw/MinGW API for MS-Windows/w32api-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/mingw/files/MinGW API for MS-Windows/) | \
    $(SED) -n 's,.*w32api-\([0-9][^>]*\)-mingw32-dev\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    # fix incompatibilities with gettext
    $(SED) 's,\(SUBLANG_BENGALI_INDIA\t\)0x01,\10x00,'    -i '$(1)/include/winnt.h'
    $(SED) 's,\(SUBLANG_PUNJABI_INDIA\t\)0x01,\10x00,'    -i '$(1)/include/winnt.h'
    $(SED) 's,\(SUBLANG_ROMANIAN_ROMANIA\t\)0x01,\10x00,' -i '$(1)/include/winnt.h'
    # fix incompatibilities with jpeg
    $(SED) 's,typedef unsigned char boolean;,,'           -i '$(1)/include/rpcndr.h'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)'
    cp -rpv '$(1)/include' '$(1)/lib' '$(PREFIX)/$(TARGET)'
endef
