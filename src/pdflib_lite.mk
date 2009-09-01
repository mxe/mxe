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

# PDFlib Lite
PKG             := pdflib_lite
$(PKG)_VERSION  := 7.0.4p4
$(PKG)_CHECKSUM := 36d3f8cedeed95ec68ae90f489d9bfb40b4c6593
$(PKG)_SUBDIR   := PDFlib-Lite-$($(PKG)_VERSION)
$(PKG)_FILE     := PDFlib-Lite-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.pdflib.com/download/pdflib-family/pdflib-lite/
$(PKG)_URL      := http://www.pdflib.com/binaries/PDFlib/$(subst .,,$(word 1,$(subst p, ,$($(PKG)_VERSION))))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.pdflib.com/download/pdflib-family/pdflib-lite/' | \
    $(SED) -n 's,.*PDFlib-Lite-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,ac_sys_system=`uname -s`,ac_sys_system=MinGW,' -i '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --without-openssl \
        --without-java \
        --without-py \
        --without-perl \
        --without-ruby \
        --without-tcl \
        --disable-php \
        --enable-cxx \
        --enable-large-files \
        CFLAGS='-D_IOB_ENTRIES=20'
    $(SED) 's,-DPDF_PLATFORM=[^ ]* ,,' -i '$(1)/config/mkcommon.inc'
    $(MAKE) -C '$(1)/libs' -j '$(JOBS)'
    $(MAKE) -C '$(1)/libs' -j 1 install
endef
