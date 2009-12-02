# Copyright (C) 2009  Volker Grabsch
#                     Bart van Andel
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

# lcms
PKG             := lcms
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.19
$(PKG)_CHECKSUM := d5b075ccffc0068015f74f78e4bc39138bcfe2d4
$(PKG)_SUBDIR   := lcms-$(subst a,,$($(PKG)_VERSION))
$(PKG)_FILE     := lcms-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.littlecms.com/
$(PKG)_URL      := http://www.littlecms.com/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc jpeg tiff zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://www.littlecms.com/downloads.htm' | \
    grep 'lcms-' | \
    $(SED) -n 's,.*lcms-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --disable-shared \
        --with-jpeg \
        --with-tiff \
        --with-zlib
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
endef
