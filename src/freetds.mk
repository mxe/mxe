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

# FreeTDS
PKG             := freetds
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.82
$(PKG)_CHECKSUM := 7e2a0c9e41c240c2d1c7f69c6f278e9a5bb80c2d
$(PKG)_SUBDIR   := freetds-$($(PKG)_VERSION)
$(PKG)_FILE     := freetds-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.freetds.org/
$(PKG)_URL      := http://ibiblio.org/pub/Linux/ALPHA/$(PKG)/stable/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv

define $(PKG)_UPDATE
    wget -q -O- 'http://freetds.cvs.sourceforge.net/viewvc/freetds/freetds/' | \
    grep '<option>R' | \
    $(SED) -n 's,.*R\([0-9][0-9_]*\)<.*,\1,p' | \
    $(SED) 's,_,.,g' | \
    head -1
endef

define $(PKG)_BUILD
    # package uses winsock2.h, so it should link to ws2_32 instead of wsock32
    $(SED) 's,wsock32,ws2_32,g' -i '$(1)'/configure

    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) 's,cross_compiling=no,cross_compiling=yes,' -i '$(1)/configure'

    # beware --with-gnutls broken detection
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --disable-rpath \
        --disable-dependency-tracking \
        --disable-shared \
        --enable-static \
        --enable-libiconv \
        --enable-msdblib \
        --with-tdsver=8.0
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
