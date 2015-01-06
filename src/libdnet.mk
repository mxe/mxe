# This file is part of MXE.
# See index.html for further information.

PKG             := libdnet
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.11
$(PKG)_CHECKSUM := e2ae8c7f0ca95655ae9f77fd4a0e2235dc4716bf
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(PKG)-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc winpcap

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/libdnet/files/libdnet/' | \
    $(SED) -n 's,.*/libdnet-\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,CYGWIN=no,CYGWIN=yes,g'                     '$(1)/configure'
    $(SED) -i 's,cat /proc/sys/kernel/ostype,,g'             '$(1)/configure'
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
