# Copyright (C) 2009  Volker Grabsch
#                     Andreas Roever
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

# Boost C++ Library
PKG             := boost
$(PKG)_VERSION  := 1_38_0
$(PKG)_CHECKSUM := b32ff8133b0a38a74553c0d33cb1d70b3ce2d8f1
$(PKG)_SUBDIR   := boost_$($(PKG)_VERSION)
$(PKG)_FILE     := boost_$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.boost.org/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/boost/boost/$(subst _,.,$($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib bzip2 expat

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/boost/files/boost/) | \
    $(SED) -n 's,.*boost_\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    echo 'using gcc : : $(TARGET)-g++ : ;' > '$(1)/user-config.jam'
    # make the build script generate .a library files instead of .lib
    $(SED) 's,<target-os>windows : lib ;,<target-os>windows : a ;,' -i '$(1)/tools/build/v2/tools/types/lib.jam'
    # compile boost jam
    cd '$(1)/tools/jam/src' && ./build.sh
    cd '$(1)' && tools/jam/src/bin.*/bjam \
        -j '$(JOBS)' \
        --user-config=user-config.jam \
        target-os=windows \
        threading=multi \
        link=static \
        threadapi=win32 \
        --layout=system \
        --without-mpi \
        --without-python \
        --prefix='$(PREFIX)/$(TARGET)' \
        --exec-prefix='$(PREFIX)/$(TARGET)/bin' \
        --libdir='$(PREFIX)/$(TARGET)/lib' \
        --includedir='$(PREFIX)/$(TARGET)/include' \
        -sEXPAT_INCLUDE='$(PREFIX)/$(TARGET)/include' \
        -sEXPAT_LIBPATH='$(PREFIX)/$(TARGET)/lib' \
        stage install
endef
