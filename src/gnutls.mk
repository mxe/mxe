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

# GnuTLS
PKG             := gnutls
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8.3
$(PKG)_CHECKSUM := c25fb354258777f9ee34b79b08eb87c024cada75
$(PKG)_SUBDIR   := gnutls-$($(PKG)_VERSION)
$(PKG)_FILE     := gnutls-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gnu.org/software/gnutls/
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gnutls/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.gnupg.org/gcrypt/gnutls/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgcrypt

define $(PKG)_UPDATE
    wget -q -O- 'http://git.savannah.gnu.org/gitweb/?p=gnutls.git;a=tags' | \
    grep '<a class="list subject"' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9]*\.[0-9]*[02468]\.[^>]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    echo '/* DEACTIVATED */' > '$(1)/gl/gai_strerror.c'
    $(SED) 's, sed , $(SED) ,g' -i '$(1)/gl/tests/Makefile.in'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-libgcrypt-prefix='$(PREFIX)/$(TARGET)' \
        --disable-nls \
        --with-included-opencdk \
        --with-included-libtasn1 \
        --with-included-libcfg \
        --with-included-lzo
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef
