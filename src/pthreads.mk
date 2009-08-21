# Copyright (C) 2009  Volker Grabsch <vog@notjusthosting.com>
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

# pthreads-w32
PKG             := pthreads
$(PKG)_VERSION  := 2-8-0
$(PKG)_CHECKSUM := da8371cb20e8e238f96a1d0651212f154d84a9ac
$(PKG)_SUBDIR   := pthreads-w32-$($(PKG)_VERSION)-release
$(PKG)_FILE     := pthreads-w32-$($(PKG)_VERSION)-release.tar.gz
$(PKG)_WEBSITE  := http://sourceware.org/pthreads-win32/
$(PKG)_URL      := ftp://sourceware.org/pub/pthreads-win32/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'ftp://sourceware.org/pub/pthreads-win32/Release_notes' | \
    $(SED) -n 's,^RELEASE \([0-9][^[:space:]]*\).*,\1,p' | \
        tr '.' '-' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) '35i\#define PTW32_STATIC_LIB' -i '$(1)/pthread.h'
    $(MAKE) -C '$(1)' -j 1 GC-static CROSS='$(TARGET)-'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m664 '$(1)/libpthreadGC2.a' '$(PREFIX)/$(TARGET)/lib/libpthread.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m664 '$(1)/pthread.h' '$(1)/sched.h' '$(1)/semaphore.h' '$(PREFIX)/$(TARGET)/include/'
endef
