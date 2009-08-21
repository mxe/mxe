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

# libMikMod
PKG             := libmikmod
$(PKG)_VERSION  := 3.2.0-beta2
$(PKG)_CHECKSUM := f16fc09ee643af295a8642f578bda97a81aaf744
$(PKG)_SUBDIR   := libmikmod-$($(PKG)_VERSION)
$(PKG)_FILE     := libmikmod-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://mikmod.raphnet.net/
$(PKG)_URL      := http://mikmod.raphnet.net/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pthreads

define $(PKG)_UPDATE
    wget -q -O- 'http://mikmod.raphnet.net/' | \
    $(SED) -n 's,.*libmikmod-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,-Dunix,,' -i '$(1)/libmikmod/Makefile.in'
    $(SED) 's,`uname`,MinGW,g' -i '$(1)/configure'
    cd '$(1)' && \
        CC='$(TARGET)-gcc' \
        NM='$(TARGET)-nm' \
        RANLIB='$(TARGET)-ranlib' \
        STRIP='$(TARGET)-strip' \
        LIBS='-lws2_32' \
        ./configure \
            --disable-shared \
            --prefix='$(PREFIX)/$(TARGET)' \
            --disable-esd
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
