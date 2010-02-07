# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# WinPcap
PKG             := winpcap
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4_1_1
$(PKG)_CHECKSUM := f2f7dd0dc29dd3d89bfdab5a9ed192aa5ffa8eb0
$(PKG)_SUBDIR   := winpcap
$(PKG)_FILE     := WpcapSrc_$($(PKG)_VERSION).zip
$(PKG)_WEBSITE  := http://www.winpcap.org/
$(PKG)_URL      := http://www.winpcap.org/install/bin/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.winpcap.org/devel.htm' | \
    $(SED) -n 's,.*WpcapSrc_\([0-9][^>]*\)\.zip.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) '/#include/ s,\\,/,g'                             -i '$(1)/packetNtx/Dll/Packet32.c'
    $(SED) 's,#include <packet32\.h>,#include <Packet32.h>,' -i '$(1)/packetNtx/Dll/Packet32.c'
    $(SED) 's,#include <StrSafe\.h>,#include <strsafe.h>,'   -i '$(1)/packetNtx/Dll/Packet32.c'
    $(SED) 's,#include <Iphlpapi\.h>,#include <iphlpapi.h>,' -i '$(1)/packetNtx/Dll/Packet32.c'
    $(SED) 's,#include <IPIfCons\.h>,#include <ipifcons.h>,' -i '$(1)/packetNtx/Dll/Packet32.c'
    cd '$(1)' && $(TARGET)-gcc -ICommon -IpacketNtx/Dll -O -c '$(1)/packetNtx/Dll/Packet32.c'
    $(TARGET)-ar rc '$(1)/libpacket.a' '$(1)/Packet32.o'
    $(TARGET)-ranlib '$(1)/libpacket.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/Common'/*.h '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libpacket.a' '$(PREFIX)/$(TARGET)/lib/'
    mv '$(1)/wpcap/libpcap/Win32/Include/ip6_misc.h' '$(1)/wpcap/libpcap/Win32/Include/IP6_misc.h'
    $(SED) 's,#include <packet32\.h>,#include <Packet32.h>,' -i '$(1)/wpcap/Win32-Extensions/Win32-Extensions.c'
    $(SED) 's,(char\*)tUstr +=,tUstr +=,' -i '$(1)/wpcap/libpcap/inet.c'
    $(SED) 's,-DHAVE_AIRPCAP_API,,'    -i '$(1)/wpcap/PRJ/GNUmakefile'
    $(SED) 's,/common,/Common,'        -i '$(1)/wpcap/PRJ/GNUmakefile'
    echo -e 'libwpcap.a: $${OBJS}'     >> '$(1)/wpcap/PRJ/GNUmakefile'
    echo -e '\t$${AR} rc $$@ $${OBJS}' >> '$(1)/wpcap/PRJ/GNUmakefile'
    echo -e '\t$${RANLIB} $$@'         >> '$(1)/wpcap/PRJ/GNUmakefile'
    echo '/* already handled by <ws2tcpip.h> */' > '$(1)/wpcap/libpcap/Win32/Src/gai_strerror.c'
    CC='$(TARGET)-gcc' \
    AR='$(TARGET)-ar' \
    RANLIB='$(TARGET)-ranlib' \
    $(MAKE) -C '$(1)/wpcap/PRJ' -j 1 libwpcap.a
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/wpcap/libpcap/'*.h '$(1)/wpcap/Win32-Extensions/'*.h '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/wpcap/PRJ/libwpcap.a' '$(PREFIX)/$(TARGET)/lib/'
endef
