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

# GCC
PKG             := gcc
$(PKG)_IGNORE   := 4.4.2
$(PKG)_VERSION  := 4.4.0
$(PKG)_CHECKSUM := 9215af6beb900ca1eef1d6a40c3dabe990203b25
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://gcc.gnu.org/
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.cs.tu-berlin.de/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := pkg_config mingwrt mingwrt-dll w32api binutils gcc-gmp gcc-mpfr gcc-tdm gcc-pthreads

define $(PKG)_UPDATE
    wget -q -O- 'http://gcc.gnu.org/viewcvs/tags/?sortby=date' | \
    grep '<a name="gcc_' | \
    $(SED) -n 's,.*<a name="gcc_\([0-9][^"]*\)_release".*,\1,p' | \
    $(SED) 's,_,.,g' | \
    head -1
endef

$(PKG)_CONFIGURE_OPTIONS := \
        --target='$(TARGET)' \
        --prefix='$(PREFIX)' \
        --enable-languages='c,c++,objc,fortran' \
        --enable-version-specific-runtime-libs \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        --disable-shared \
        --without-x \
        --disable-win32-registry \
        --enable-sjlj-exceptions

define $(PKG)_BUILD
    # unpack TDM-GCC
    mkdir '$(1)/gcc-tdm'
    cd    '$(1)/gcc-tdm' && $(call UNPACK_PKG_ARCHIVE,gcc-tdm)
    # apply TDM-GCC patches
    cd '$(1)' && \
        for p in '$(1)'/gcc-tdm/*.patch; do \
            $(SED) 's,\r$$,,' -i "$$p" || exit 1; \
            patch -p1 < "$$p" || exit 1; \
        done
    # unpack support libraries
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-gmp)
    mv '$(1)/$(gcc-gmp_SUBDIR)' '$(1)/gmp'
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-mpfr)
    mv '$(1)/$(gcc-mpfr_SUBDIR)' '$(1)/mpfr'
    # build everything of GCC except libgomp and libmudflap
    mkdir '$(1)/build'
    cd    '$(1)/build' && '$(1)/configure' \
        $(gcc_CONFIGURE_OPTIONS) \
        --enable-threads=win32 \
        --disable-libgomp \
        --disable-libmudflap
    $(MAKE) -C '$(1)/build' -j '$(JOBS)'
    $(MAKE) -C '$(1)/build' -j 1 install
    # unpack and build pthreads (needed by libgomp)
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-pthreads)
    $(SED) '35i\#define PTW32_STATIC_LIB' -i '$(1)/$(gcc-pthreads_SUBDIR)/pthread.h'
    $(SED) 's,#include "config.h",,'      -i '$(1)/$(gcc-pthreads_SUBDIR)/pthread.h'
    $(MAKE) -C '$(1)/$(gcc-pthreads_SUBDIR)' -j 1 GC-static CROSS='$(TARGET)-'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m664 '$(1)/$(gcc-pthreads_SUBDIR)/libpthreadGC2.a' '$(PREFIX)/$(TARGET)/lib/libpthread.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m664 '$(1)/$(gcc-pthreads_SUBDIR)/pthread.h'   '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m664 '$(1)/$(gcc-pthreads_SUBDIR)/sched.h'     '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m664 '$(1)/$(gcc-pthreads_SUBDIR)/semaphore.h' '$(PREFIX)/$(TARGET)/include/'
    # build libgomp
    $(SED) 's,cross_compiling=no,cross_compiling=yes,' -i '$(1)/libgomp/configure'
    mkdir '$(1)/build/$(TARGET)/libgomp'
    cd    '$(1)/build/$(TARGET)/libgomp' && '$(1)/libgomp/configure' \
        $(gcc_CONFIGURE_OPTIONS) \
        --host='$(TARGET)' \
        LIBS='-lws2_32'
    $(MAKE) -C '$(1)/build/$(TARGET)/libgomp' -j '$(JOBS)' install
endef
