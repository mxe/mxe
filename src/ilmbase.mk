# Copyright (C) 2009  Volker Grabsch <vog@notjusthosting.com>
#                     Martin Lambers
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

# IlmBase
PKG             := ilmbase
$(PKG)_VERSION  := 1.0.1
$(PKG)_CHECKSUM := 143adc547be83c6df75831ae957eef4b2706c9c0
$(PKG)_SUBDIR   := ilmbase-$($(PKG)_VERSION)
$(PKG)_FILE     := ilmbase-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.openexr.com/
$(PKG)_URL      := http://download.savannah.nongnu.org/releases/openexr/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.openexr.com/downloads.html' | \
    grep 'ilmbase-' | \
    $(SED) -n 's,.*ilmbase-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) 's,cross_compiling=no,cross_compiling=yes,' -i '$(1)/configure'
    # build the win32 thread sources instead of the posix thread sources
    $(SED) 's,IlmThreadPosix\.,IlmThreadWin32\.,'                   -i '$(1)/IlmThread/Makefile.in'
    $(SED) 's,IlmThreadSemaphorePosix\.,IlmThreadSemaphoreWin32\.,' -i '$(1)/IlmThread/Makefile.in'
    $(SED) 's,IlmThreadMutexPosix\.,IlmThreadMutexWin32\.,'         -i '$(1)/IlmThread/Makefile.in'
    echo '/* disabled */' > '$(1)/IlmThread/IlmThreadSemaphorePosixCompat.cpp'
    # Because of the previous changes, '--disable-threading' will not disable
    # threading. It will just disable the unwanted check for pthread.
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-threading
    # do the first build step by hand, because programs are built that
    # generate source files
    cd '$(1)/Half' && g++ eLut.cpp -o eLut
    '$(1)/Half/eLut' > '$(1)/eLut.h'
    cd '$(1)/Half' && g++ toFloat.cpp -o toFloat
    '$(1)/Half/toFloat' > '$(1)/toFloat.h'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
