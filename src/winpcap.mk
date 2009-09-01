# Copyright (C) 2009  Volker Grabsch
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject
# to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# WinPcap
PKG             := winpcap
$(PKG)_VERSION  := 4_0_2
$(PKG)_CHECKSUM := faa4e0cd73352d400d123be63b9c6c02c7e132d1
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
    mv '$(1)/Common' '$(1)/common'
    -cp -p '$(1)/common/Devioctl.h'   '$(1)/common/devioctl.h'
    -cp -p '$(1)/common/Ntddndis.h'   '$(1)/common/ntddndis.h'
    -cp -p '$(1)/common/Ntddpack.h'   '$(1)/common/ntddpack.h'
    -cp -p '$(1)/common/Packet32.h'   '$(1)/common/packet32.h'
    -cp -p '$(1)/common/WpcapNames.h' '$(1)/common/wpcapnames.h'
    $(SED) 's,(PCHAR)winpcap_hdr +=,winpcap_hdr +=,' -i '$(1)/Packet9x/DLL/Packet32.c'
    cd '$(1)' && $(TARGET)-gcc -Icommon -O -c '$(1)/Packet9x/DLL/Packet32.c'
    $(TARGET)-ar rc '$(1)/libpacket.a' '$(1)/Packet32.o'
    $(TARGET)-ranlib '$(1)/libpacket.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/common'/*.h '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libpacket.a' '$(PREFIX)/$(TARGET)/lib/'
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
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/wpcap/libpcap/'*.h '$(1)/wpcap/Win32-Extensions/'*.h '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/wpcap/PRJ/libwpcap.a' '$(PREFIX)/$(TARGET)/lib/'
endef
