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

# libmng
PKG             := libmng
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.10
$(PKG)_CHECKSUM := c21c84b614500ae1a41c6595d5f81c596e406ca2
$(PKG)_SUBDIR   := libmng-$($(PKG)_VERSION)
$(PKG)_FILE     := libmng-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.libmng.com/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/libmng/libmng-devel/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib jpeg

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/libmng/files/libmng-devel/) | \
    $(SED) -n 's,.*libmng-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' \
        -f '$(1)'/makefiles/makefile.unix \
        CC=$(TARGET)-gcc
    $(TARGET)-ranlib '$(1)/libmng.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libmng.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/libmng.h' '$(1)/libmng_conf.h' '$(1)/libmng_types.h' '$(PREFIX)/$(TARGET)/include/'
endef
