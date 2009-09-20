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

# MinGW Windows API
PKG             := w32api
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.13
$(PKG)_CHECKSUM := 5eb7d8ec0fe032a92bea3a2c8282a78df2f1793c
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := w32api-$($(PKG)_VERSION)-mingw32-dev.tar.gz
$(PKG)_WEBSITE  := http://mingw.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mingw/MinGW API for MS-Windows/Current Release_ w32api-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/mingw/files/MinGW API for MS-Windows/) | \
    $(SED) -n 's,.*w32api-\([0-9][^>]*\)-mingw32-dev\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    # fix incompatibilities with gettext
    $(SED) 's,\(SUBLANG_BENGALI_INDIA\t\)0x01,\10x00,'    -i '$(1)/include/winnt.h'
    $(SED) 's,\(SUBLANG_PUNJABI_INDIA\t\)0x01,\10x00,'    -i '$(1)/include/winnt.h'
    $(SED) 's,\(SUBLANG_ROMANIAN_ROMANIA\t\)0x01,\10x00,' -i '$(1)/include/winnt.h'
    # fix incompatibilities with jpeg
    $(SED) 's,typedef unsigned char boolean;,,'           -i '$(1)/include/rpcndr.h'
    # fix missing definitions for WinPcap and libdnet
    $(SED) '1i\#include <wtypes.h>'                       -i '$(1)/include/iphlpapi.h'
    $(SED) '1i\#include <wtypes.h>'                       -i '$(1)/include/wincrypt.h'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)'
    cp -rpv '$(1)/include' '$(1)/lib' '$(PREFIX)/$(TARGET)'
endef
