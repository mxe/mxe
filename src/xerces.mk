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

# Xerces-C++
PKG             := xerces
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.1
$(PKG)_CHECKSUM := 71e4efee5397dd45d6bafad34bf3bc766bc2a085
$(PKG)_SUBDIR   := xerces-c-$($(PKG)_VERSION)
$(PKG)_FILE     := xerces-c-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://xerces.apache.org/xerces-c/
$(PKG)_URL      := http://apache.linux-mirror.org/xerces/c/$(word 1,$(subst ., ,$($(PKG)_VERSION)))/sources/$($(PKG)_FILE)
$(PKG)_URL_2    := http://www.apache.org/dist/xerces/c/$(word 1,$(subst ., ,$($(PKG)_VERSION)))/sources/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv curl

define $(PKG)_UPDATE
    wget -q -O- 'http://svn.apache.org/viewvc/xerces/c/tags/?sortby=date' | \
    grep '<a name="' | \
    $(SED) -n 's,.*<a name="Xerces-C_\([0-9][^"]*\)".*,\1,p' | \
    $(SED) 's,_,.,g' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-libtool-lock \
        --disable-pretty-make \
        --enable-threads \
        --enable-network \
        --enable-netaccessor-curl \
        --disable-netaccessor-socket \
        --disable-netaccessor-cfurl \
        --disable-netaccessor-winsock \
        --enable-transcoder-iconv \
        --disable-transcoder-gnuiconv \
        --disable-transcoder-icu \
        --disable-transcoder-macosunicodeconverter \
        --disable-transcoder-windows \
        --enable-msgloader-inmemory \
        --disable-msgloader-iconv \
        --disable-msgloader-icu \
        --with-curl \
        --without-icu \
        LIBS='-lws2_32'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
