# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := winpcap
$(PKG)_WEBSITE  := https://www.winpcap.org/
$(PKG)_DESCR    := WinPcap
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4_1_3
$(PKG)_CHECKSUM := 346a93f6b375ac4c1add5c8c7178498f1feed4172fb33383474a91b48ec6633a
$(PKG)_SUBDIR   := winpcap
$(PKG)_FILE     := WpcapSrc_$($(PKG)_VERSION).zip
$(PKG)_URL      := https://www.winpcap.org/install/bin/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.winpcap.org/devel.htm' | \
    $(SED) -n 's,.*WpcapSrc_\([0-9][^>]*\)\.zip.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # build
    cd '$(1)' && $(TARGET)-gcc -ICommon -IpacketNtx/Dll -O -c '$(1)/packetNtx/Dll/Packet32.c' -D_WINNT4
    cd '$(1)' && $(TARGET)-gcc -ICommon -IpacketNtx/Dll -O -c '$(1)/packetNtx/Dll/AdInfo.c'
    cd '$(1)' && $(TARGET)-gcc -ICommon -IpacketNtx/Dll -O -c '$(1)/packetNtx/Dll/NpfImExt.c'
    $(TARGET)-ar rc '$(1)/libpacket.a' '$(1)/Packet32.o' '$(1)/AdInfo.o' '$(1)/NpfImExt.o'
    $(TARGET)-ranlib '$(1)/libpacket.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libpacket.a' '$(PREFIX)/$(TARGET)/lib/'

    mv '$(1)/wpcap/libpcap/Win32/Include/ip6_misc.h' '$(1)/file.tmp'
    mv '$(1)/file.tmp' '$(1)/wpcap/libpcap/Win32/Include/IP6_misc.h'

    CC='$(TARGET)-gcc' \
    AR='$(TARGET)-ar' \
    RANLIB='$(TARGET)-ranlib' \
    $(MAKE) -C '$(1)/wpcap/PRJ' -j 1 libwpcap.a

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 \
         $(1)/wpcap/libpcap/Win32/Include/IP6_misc.h \
         $(1)/wpcap/libpcap/pcap-namedb.h \
         $(1)/wpcap/libpcap/pcap-bpf.h \
         $(1)/wpcap/libpcap/remote-ext.h \
         $(1)/Common/Packet32.h \
         $(1)/wpcap/Win32-Extensions/Win32-Extensions.h \
         $(1)/wpcap/libpcap/Win32/Include/bittypes.h \
         $(1)/wpcap/libpcap/pcap-stdinc.h \
         $(1)/wpcap/libpcap/pcap.h \
        '$(PREFIX)/$(TARGET)/include/'

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/pcap'
    $(INSTALL) -m644 \
        $(1)/wpcap/libpcap/pcap/namedb.h \
        $(1)/wpcap/libpcap/pcap/sll.h \
        $(1)/wpcap/libpcap/pcap/bpf.h \
        $(1)/wpcap/libpcap/pcap/usb.h \
        $(1)/wpcap/libpcap/pcap/pcap.h \
        $(1)/wpcap/libpcap/pcap/bluetooth.h \
        $(1)/wpcap/libpcap/pcap/vlan.h \
        '$(PREFIX)/$(TARGET)/include/pcap/'

    $(INSTALL) -m644 '$(1)/wpcap/PRJ/libwpcap.a' '$(PREFIX)/$(TARGET)/lib/'

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $($(PKG)_DESCR)'; \
     echo 'Requires:'; \
     echo 'Libs: -lwpcap -lpacket -lws2_32 -lversion'; \
     echo 'Cflags: -I$(PREFIX)/$(TARGET)/include/pcap';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall \
        '$(SOURCE_DIR)/Examples-pcap/basic_dump_ex/basic_dump_ex.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
