# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# libdnet
PKG             := libdnet
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.11
$(PKG)_CHECKSUM := e2ae8c7f0ca95655ae9f77fd4a0e2235dc4716bf
$(PKG)_SUBDIR   := libdnet-$($(PKG)_VERSION)
$(PKG)_FILE     := libdnet-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://libdnet.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/libdnet/libdnet/libdnet-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc winpcap

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/libdnet/files/libdnet/) | \
    $(SED) -n 's,.*libdnet-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) 's,CYGWIN=no,CYGWIN=yes,g'                     -i '$(1)/configure'
    $(SED) 's,cat /proc/sys/kernel/ostype,,g'             -i '$(1)/configure'
    $(SED) 's,test -d /usr/include/mingw,true,'           -i '$(1)/configure'
    $(SED) 's,Iphlpapi,iphlpapi,g'                        -i '$(1)/configure'
    $(SED) 's,packet32\.h,Packet32.h,g'                   -i '$(1)/configure'
    $(SED) 's,packet\.lib,libpacket.a,'                   -i '$(1)/configure'
    $(SED) 's,-lpacket,-lpacket -lws2_32,g'               -i '$(1)/configure'
    $(SED) 's,/usr/include,$(PREFIX)/$(TARGET)/include,g' -i '$(1)/configure'
    $(SED) 's,#include <Ntddndis.h>,#include <ddk/ntddndis.h>,' -i '$(1)/src/eth-win32.c'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
