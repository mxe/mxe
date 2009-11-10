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
