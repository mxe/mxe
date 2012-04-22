# This file is part of MXE.
# See index.html for further information.

PKG             := winpcap
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 9155687ab23dbb2348e7cf93caf8a84f51e94795
$(PKG)_SUBDIR   := winpcap
$(PKG)_FILE     := WpcapSrc_$($(PKG)_VERSION).zip
$(PKG)_URL      := http://www.winpcap.org/install/bin/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.winpcap.org/devel.htm' | \
    $(SED) -n 's,.*WpcapSrc_\([0-9][^>]*\)\.zip.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # build
    cd '$(1)' && $(TARGET)-gcc -ICommon -IpacketNtx/Dll -O -c '$(1)/packetNtx/Dll/Packet32.c'
    $(TARGET)-ar rc '$(1)/libpacket.a' '$(1)/Packet32.o'
    $(TARGET)-ranlib '$(1)/libpacket.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/Common'/*.h '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libpacket.a' '$(PREFIX)/$(TARGET)/lib/'

    mv '$(1)/wpcap/libpcap/Win32/Include/ip6_misc.h' '$(1)/file.tmp'
    mv '$(1)/file.tmp' '$(1)/wpcap/libpcap/Win32/Include/IP6_misc.h'

    CC='$(TARGET)-gcc' \
    AR='$(TARGET)-ar' \
    RANLIB='$(TARGET)-ranlib' \
    $(MAKE) -C '$(1)/wpcap/PRJ' -j 1 libwpcap.a
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/wpcap/libpcap/'*.h '$(1)/wpcap/Win32-Extensions/'*.h '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/wpcap/PRJ/libwpcap.a' '$(PREFIX)/$(TARGET)/lib/'
endef

$(PKG)_BUILD_i686-static-mingw32 = $($(PKG)_BUILD)
