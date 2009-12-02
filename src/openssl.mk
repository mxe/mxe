# Copyright (C) 2009  Mark Brand
#                     Volker Grabsch
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

# openssl
PKG             := openssl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.8l
$(PKG)_CHECKSUM := d3fb6ec89532ab40646b65af179bb1770f7ca28f
$(PKG)_SUBDIR   := openssl-$($(PKG)_VERSION)
$(PKG)_FILE     := openssl-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.openssl.org/
$(PKG)_URL      := http://www.openssl.org/source/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.openssl.org/source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://www.openssl.org/source/' | \
    grep '<a href="openssl-' | \
    $(SED) -n 's,.*openssl-\([0-9][0-9a-z.]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # workarounds according to
    # http://wagner.pp.ru/~vitus/articles/openssl-mingw.html
    $(SED) 's,^$$IsMK1MF=1.*,,' -i '$(1)'/Configure
    $(SED) 's,static type _hide_##name,type _hide_##name,' -i '$(1)'/e_os2.h

    # use winsock2 instead of winsock
    $(SED) 's,wsock32,ws2_32,g' -i '$(1)'/Configure
    find '$(1)' -type f -exec \
        $(SED) 's,winsock\.h,winsock2.h,g' -i {} \;

    cd '$(1)' && CC='$(TARGET)-gcc' ./Configure \
        mingw \
        zlib \
        no-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' install -j 1 \
        CC='$(TARGET)-gcc' \
        RANLIB='$(TARGET)-ranlib' \
        AR='$(TARGET)-ar rcu'
endef
