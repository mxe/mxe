# WinPcap
# http://www.winpcap.org/

PKG            := winpcap
$(PKG)_VERSION := 4_0_2
$(PKG)_SUBDIR  := winpcap
$(PKG)_FILE    := WpcapSrc_$($(PKG)_VERSION).zip
$(PKG)_URL     := http://www.winpcap.org/install/bin/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.winpcap.org/devel.htm' | \
    $(SED) -n 's,.*WpcapSrc_\([0-9][^>]*\)\.zip.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mv '$(1)/Common' '$(1)/common'
    cp -p '$(1)/common/Devioctl.h'   '$(1)/common/devioctl.h'
    cp -p '$(1)/common/Ntddndis.h'   '$(1)/common/ntddndis.h'
    cp -p '$(1)/common/Ntddpack.h'   '$(1)/common/ntddpack.h'
    cp -p '$(1)/common/Packet32.h'   '$(1)/common/packet32.h'
    cp -p '$(1)/common/WpcapNames.h' '$(1)/common/wpcapnames.h'
    $(SED) 's,(PCHAR)winpcap_hdr +=,winpcap_hdr +=,' -i '$(1)/Packet9x/DLL/Packet32.c'
    cd '$(1)' && $(TARGET)-gcc -Icommon -O -c '$(1)/Packet9x/DLL/Packet32.c'
    $(TARGET)-ar rc '$(1)/libpacket.a' '$(1)/Packet32.o'
    $(TARGET)-ranlib '$(1)/libpacket.a'
    install -d '$(PREFIX)/$(TARGET)/include'
    install -m644 '$(1)/common'/*.h '$(PREFIX)/$(TARGET)/include/'
    install -d '$(PREFIX)/$(TARGET)/lib'
    install -m644 '$(1)/libpacket.a' '$(PREFIX)/$(TARGET)/lib/'
    mv '$(1)/wpcap/libpcap/Win32/Include/ip6_misc.h' '$(1)/wpcap/libpcap/Win32/Include/IP6_misc.h'
    $(SED) 's,(char\*)tUstr +=,tUstr +=,' -i '$(1)/wpcap/libpcap/inet.c'
    $(SED) 's,-DHAVE_AIRPCAP_API,,'    -i '$(1)/wpcap/PRJ/GNUmakefile'
    echo -e 'libwpcap.a: $${OBJS}'     >> '$(1)/wpcap/PRJ/GNUmakefile'
    echo -e '\t$${AR} rc $$@ $${OBJS}' >> '$(1)/wpcap/PRJ/GNUmakefile'
    echo -e '\t$${RANLIB} $$@'         >> '$(1)/wpcap/PRJ/GNUmakefile'
    echo '/* already handled by <ws2tcpip.h> */' > '$(1)/wpcap/libpcap/Win32/Src/gai_strerror.c'
    CC='$(TARGET)-gcc' \
    AR='$(TARGET)-ar' \
    RANLIB='$(TARGET)-ranlib' \
    $(MAKE) -C '$(1)/wpcap/PRJ' -j 1 libwpcap.a
    install -d '$(PREFIX)/$(TARGET)/include'
    install -m644 '$(1)/wpcap/libpcap/'*.h '$(1)/wpcap/Win32-Extensions/'*.h '$(PREFIX)/$(TARGET)/include/'
    install -d '$(PREFIX)/$(TARGET)/lib'
    install -m644 '$(1)/wpcap/PRJ/libwpcap.a' '$(PREFIX)/$(TARGET)/lib/'
endef
