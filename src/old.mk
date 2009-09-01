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

# old
PKG             := old
$(PKG)_VERSION  := 0.17
$(PKG)_CHECKSUM := d519a8282b0774c344ffeb1b4899f8be53d6d7b3
$(PKG)_SUBDIR   := old-$($(PKG)_VERSION)
$(PKG)_FILE     := old-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://blitiri.com.ar/p/old/
$(PKG)_URL      := http://blitiri.com.ar/p/old/files/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://blitiri.com.ar/p/old/' | \
    grep 'old-' | \
    $(SED) -n 's,.*old-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && $(TARGET)-gcc -O3 -Iinclude -c -o libold.o lib/libold.c
    cd '$(1)' && $(TARGET)-ar cr libold.a libold.o
    $(TARGET)-ranlib '$(1)/libold.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libold.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/lib/old.h' '$(PREFIX)/$(TARGET)/include/'
endef
