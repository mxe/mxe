# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libdnet
$(PKG)_WEBSITE  := https://libdnet.sourceforge.io/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.11
$(PKG)_CHECKSUM := 0eb78415c8f2564c2f1e8ad36e98473348d9c94852f796a226360c716cc7ca53
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(PKG)-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc winpcap

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/libdnet/files/libdnet/' | \
    $(SED) -n 's,.*/libdnet-\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,CYGWIN=no,CYGWIN=yes,g'                     '$(1)/configure'
    $(SED) -i 's,cat /proc/sys/kernel/ostype,,g'             '$(1)/configure'
    $(SED) -i 's,/dev/tun0,false,g'                          '$(1)/configure'
    $(SED) -i 's,test -d /usr/include/mingw,true,'           '$(1)/configure'
    $(SED) -i 's,Iphlpapi,iphlpapi,g'                        '$(1)/configure'
    $(SED) -i 's,packet32\.h,Packet32.h,g'                   '$(1)/configure'
    $(SED) -i 's,packet\.lib,libpacket.a,'                   '$(1)/configure'
    $(SED) -i 's,-lpacket,-lpacket -lws2_32,g'               '$(1)/configure'
    $(SED) -i 's,/usr/include,$(PREFIX)/$(TARGET)/include,g' '$(1)/configure'
    $(SED) -i 's,#include <Ntddndis.h>,#include <ntddndis.h>,' '$(1)/src/eth-win32.c'
    $(SED) -i 's,-mno-cygwin,,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_SHARED =
