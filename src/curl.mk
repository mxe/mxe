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

# cURL
PKG             := curl
$(PKG)_VERSION  := 7.19.5
$(PKG)_CHECKSUM := e9256f93f5a8c7f40a3c8696c2841a6c5c2b1bf7
$(PKG)_SUBDIR   := curl-$($(PKG)_VERSION)
$(PKG)_FILE     := curl-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://curl.haxx.se/libcurl/
$(PKG)_URL      := http://curl.haxx.se/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gnutls libidn

define $(PKG)_UPDATE
    wget -q -O- 'http://curl.haxx.se/changes.html' | \
    $(SED) -n 's,.*Fixed in \([0-9][^ ]*\) - .*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,-I@includedir@,-I@includedir@ -DCURL_STATICLIB,' -i '$(1)/curl-config.in'
    $(SED) 's,GNUTLS_ENABLED = 1,GNUTLS_ENABLED=1,' -i '$(1)/configure'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) 's,cross_compiling=no,cross_compiling=yes,' -i '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-gnutls='$(PREFIX)/$(TARGET)' \
        --with-libidn='$(PREFIX)/$(TARGET)' \
        LIBS="-lgcrypt -liconv `$(PREFIX)/$(TARGET)/bin/gpg-error-config --libs`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
