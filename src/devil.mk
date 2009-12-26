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

# DevIL
PKG             := devil
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.7.8
$(PKG)_CHECKSUM := bc27e3e830ba666a3af03548789700d10561fcb1
$(PKG)_SUBDIR   := devil-$($(PKG)_VERSION)
$(PKG)_FILE     := DevIL-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://openil.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/openil/DevIL/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib openexr jpeg jasper lcms libmng libpng tiff sdl

define $(PKG)_UPDATE
    wget -q -O- 'http://openil.svn.sourceforge.net/viewvc/openil/tags/?sortby=date' | \
    grep '<a name="' | \
    $(SED) -n 's,.*<a name="release-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,__declspec(dllimport),,' -i '$(1)/include/IL/il.h'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) 's,cross_compiling=no,cross_compiling=yes,' -i '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-ILU \
        --enable-ILUT \
        --disable-allegro \
        --enable-directx8 \
        --enable-directx9 \
        --enable-opengl \
        --enable-sdl \
        --disable-sdltest \
        --disable-wdp \
        --with-zlib \
        --without-squish \
        --without-nvtt \
        --without-x \
        --without-examples
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= INFO_DEPS=
endef
