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

# libxslt
PKG             := libxslt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.26
$(PKG)_CHECKSUM := 69f74df8228b504a87e2b257c2d5238281c65154
$(PKG)_SUBDIR   := libxslt-$($(PKG)_VERSION)
$(PKG)_FILE     := libxslt-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://xmlsoft.org/XSLT/
$(PKG)_URL      := ftp://xmlsoft.org/libxslt/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libxml2 libgcrypt

define $(PKG)_UPDATE
    wget -q -O- 'ftp://xmlsoft.org/libxslt/' | \
    $(SED) -n 's,.*LATEST_LIBXSLT_IS_\([0-9][^>]*\)</a>.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --without-debug \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-libxml-prefix='$(PREFIX)/$(TARGET)' \
        LIBGCRYPT_CONFIG='$(PREFIX)/$(TARGET)/bin/libgcrypt-config' \
        --without-python \
        --without-plugins
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
