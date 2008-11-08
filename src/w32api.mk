# MinGW Windows API
# http://mingw.sourceforge.net/

PKG            := w32api
$(PKG)_VERSION := 3.11
$(PKG)_SUBDIR  := .
$(PKG)_FILE    := w32api-$($(PKG)_VERSION).tar.gz
$(PKG)_URL     := http://$(SOURCEFORGE_MIRROR)/mingw/$($(PKG)_FILE)
$(PKG)_DEPS    :=

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=2435&package_id=11550' | \
    $(SED) -n 's,.*w32api-\([0-9][^>]*\)-src\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # fix incompatibilities with gettext
    $(SED) 's,\(SUBLANG_BENGALI_INDIA\t\)0x01,\10x00,'    -i '$(2)/include/winnt.h'
    $(SED) 's,\(SUBLANG_PUNJABI_INDIA\t\)0x01,\10x00,'    -i '$(2)/include/winnt.h'
    $(SED) 's,\(SUBLANG_ROMANIAN_ROMANIA\t\)0x01,\10x00,' -i '$(2)/include/winnt.h'
    # fix incompatibilities with jpeg
    $(SED) 's,typedef unsigned char boolean;,,'           -i '$(2)/include/rpcndr.h'
    # fix missing definitions for WinPcap and libdnet
    $(SED) '1i\#include <wtypes.h>'                       -i '$(2)/include/iphlpapi.h'
    $(SED) '1i\#include <wtypes.h>'                       -i '$(2)/include/wincrypt.h'
    mkdir -p '$(PREFIX)/$(TARGET)'
    cp -rpv '$(2)/include' '$(2)/lib' '$(PREFIX)/$(TARGET)'
endef
