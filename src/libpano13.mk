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

# libpano13
PKG             := libpano13
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.9.15_beta3
$(PKG)_CHECKSUM := 963a7c18b57144b174df063031ed376133a6e522
$(PKG)_SUBDIR   := libpano13-$(word 1,$(subst _, ,$($(PKG)_VERSION)))
$(PKG)_FILE     := libpano13-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://panotools.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/panotools/libpano13/libpano13-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc jpeg tiff libpng zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/api/file/index/project-id/96188/rss?path=/libpano13' | \
    grep '/download</link>' | \
    $(SED) -n 's,.*libpano13-\([0-9].*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) 's,WINDOWSX\.H,windowsx.h,'                                                  -i '$(1)/sys_win.h'
    $(SED) 's,\$${WINDRES-windres},$(TARGET)-windres,'                                  -i '$(1)/build/win32/compile-resource'
    $(SED) 's,m4 -DBUILDNUMBER=\$$buildnumber,$(SED) "s/BUILDNUMBER/\$$buildnumber/g",' -i '$(1)/build/win32/compile-resource'
    $(SED) 's,mv.*libpano13\.dll.*,,'                                                   -i '$(1)/Makefile.in'
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --disable-shared \
        --with-jpeg='$(PREFIX)/$(TARGET)'/lib \
        --with-tiff='$(PREFIX)/$(TARGET)'/lib \
        --with-png='$(PREFIX)/$(TARGET)'/lib \
        --with-zlib='$(PREFIX)/$(TARGET)'/lib
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
endef
