# MinGW Windows API

PKG            := w32api
$(PKG)_VERSION := 3.13-mingw32
$(PKG)_SUBDIR  := .
$(PKG)_FILE    := w32api-$($(PKG)_VERSION)-dev.tar.gz
$(PKG)_WEBSITE := http://mingw.sourceforge.net/
$(PKG)_URL     := http://$(SOURCEFORGE_MIRROR)/mingw/$($(PKG)_FILE)
$(PKG)_DEPS    :=

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=2435&package_id=11550' | \
    $(SED) -n 's,.*w32api-\([0-9][^>]*\)-src\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # fix incompatibilities with gettext
    $(SED) 's,\(SUBLANG_BENGALI_INDIA\t\)0x01,\10x00,'    -i '$(1)/include/winnt.h'
    $(SED) 's,\(SUBLANG_PUNJABI_INDIA\t\)0x01,\10x00,'    -i '$(1)/include/winnt.h'
    $(SED) 's,\(SUBLANG_ROMANIAN_ROMANIA\t\)0x01,\10x00,' -i '$(1)/include/winnt.h'
    # fix incompatibilities with jpeg
    $(SED) 's,typedef unsigned char boolean;,,'           -i '$(1)/include/rpcndr.h'
    # fix missing definitions for WinPcap and libdnet
    $(SED) '1i\#include <wtypes.h>'                       -i '$(1)/include/iphlpapi.h'
    $(SED) '1i\#include <wtypes.h>'                       -i '$(1)/include/wincrypt.h'
    install -d '$(PREFIX)/$(TARGET)'
    cp -rpv '$(1)/include' '$(1)/lib' '$(PREFIX)/$(TARGET)'
endef
