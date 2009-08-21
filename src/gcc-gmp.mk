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

# GMP for GCC
PKG             := gcc-gmp
$(PKG)_VERSION  := 4.3.0
$(PKG)_CHECKSUM := 86dbd8a6b2fbb4c75760a80009227c9a11b801a9
$(PKG)_SUBDIR   := gmp-$($(PKG)_VERSION)
$(PKG)_FILE     := gmp-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gmplib.org/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/tdm-gcc/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/tdm-gcc/files/Sources/) | \
    $(SED) -n 's,.*gmp-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef
