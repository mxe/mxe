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

# pkg-config
PKG             := pkg_config
$(PKG)_VERSION  := 0.23
$(PKG)_CHECKSUM := b59dddd6b5320bd74c0f74b3339618a327096b2a
$(PKG)_SUBDIR   := pkg-config-$($(PKG)_VERSION)
$(PKG)_FILE     := pkg-config-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://pkg-config.freedesktop.org/
$(PKG)_URL      := http://pkgconfig.freedesktop.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    wget -q -O- 'http://pkgconfig.freedesktop.org/' | \
    $(SED) -n 's,.*current release of pkg-config is version \([0-9][^ ]*\) and.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
    $(INSTALL) -d                       '$(PREFIX)/bin'
    rm -f                               '$(PREFIX)/bin/$(TARGET)-pkg-config'
    ln -s '../$(TARGET)/bin/pkg-config' '$(PREFIX)/bin/$(TARGET)-pkg-config'
endef
