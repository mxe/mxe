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

# libodbc++
PKG             := libodbc++
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.5
$(PKG)_CHECKSUM := 8a77921b21c23926042c413f4a7a187a3656025b
$(PKG)_SUBDIR   := libodbc++-$($(PKG)_VERSION)
$(PKG)_FILE     := libodbc++-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://libodbcxx.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/libodbcxx/libodbc++/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://libodbcxx.svn.sourceforge.net/viewvc/libodbcxx/tags/?sortby=date' | \
    grep '<a name="' | \
    $(SED) -n 's,.*<a name="libodbc++-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
      --prefix='$(PREFIX)/$(TARGET)' \
      --host='$(TARGET)' \
      --disable-shared \
      --without-tests \
      --disable-dependency-tracking
    $(MAKE) -C '$(1)' -j '$(JOBS)' install doxygen= progref_dist_files=
endef
