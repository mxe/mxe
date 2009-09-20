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

# TDM-GCC
PKG             := gcc
$(PKG)_IGNORE   := 4.4.1-tdm-1
$(PKG)_VERSION  := 4.4.0-tdm-1
$(PKG)_CHECKSUM := ec1c81acf0581b4f1e2d5498ce9cd015b63e917b
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := gcc-$($(PKG)_VERSION)-srcbase-2.zip
$(PKG)_WEBSITE  := http://www.tdragon.net/recentgcc/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/tdm-gcc/Sources/TDM Sources/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := pkg_config mingwrt w32api binutils gcc-gmp gcc-mpfr gcc-core gcc-g++ gcc-objc gcc-fortran gcc-pthreads

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/tdm-gcc/files/Sources/) | \
    $(SED) -n 's,.*gcc-\([0-9][^>]*\)-srcbase[-0-9]*\.zip.*,\1,p' | \
    tail -1
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
    # unpack GCC
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-core)
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-g++)
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-objc)
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-fortran)
    # apply TDM patches to GCC
    cd '$(1)/$(gcc-core_SUBDIR)' && \
        for p in '$(1)'/*.patch; do \
            patch -p1 < "$$p"; \
        done
    # unpack support libraries
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-gmp)
    mv '$(1)/$(gcc-gmp_SUBDIR)' '$(1)/$(gcc-core_SUBDIR)/gmp'
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-mpfr)
    mv '$(1)/$(gcc-mpfr_SUBDIR)' '$(1)/$(gcc-core_SUBDIR)/mpfr'
    # build everything of GCC except libgomp and libmudflap
    mkdir '$(1)/build'
    cd    '$(1)/build' && '$(1)/$(gcc-core_SUBDIR)/configure' \
        $(gcc_CONFIGURE_OPTIONS) \
        --enable-threads=win32 \
        --disable-libgomp \
        --disable-libmudflap
    $(MAKE) -C '$(1)/build' -j '$(JOBS)'
    $(MAKE) -C '$(1)/build' -j 1 install
    # unpack and build pthreads (needed by libgomp)
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-pthreads)
    $(SED) '35i\#define PTW32_STATIC_LIB' -i '$(1)/$(gcc-pthreads_SUBDIR)/pthread.h'
    $(MAKE) -C '$(1)/$(gcc-pthreads_SUBDIR)' -j 1 GC-static CROSS='$(TARGET)-'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m664 '$(1)/$(gcc-pthreads_SUBDIR)/libpthreadGC2.a' '$(PREFIX)/$(TARGET)/lib/libpthread.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m664 '$(1)/$(gcc-pthreads_SUBDIR)/pthread.h'   '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m664 '$(1)/$(gcc-pthreads_SUBDIR)/sched.h'     '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m664 '$(1)/$(gcc-pthreads_SUBDIR)/semaphore.h' '$(PREFIX)/$(TARGET)/include/'
    # build libgomp
    $(SED) 's,cross_compiling=no,cross_compiling=yes,' -i '$(1)/$(gcc-core_SUBDIR)/libgomp/configure'
    mkdir '$(1)/build/$(TARGET)/libgomp'
    cd    '$(1)/build/$(TARGET)/libgomp' && '$(1)/$(gcc-core_SUBDIR)/libgomp/configure' \
        $(gcc_CONFIGURE_OPTIONS) \
        --host='$(TARGET)' \
        LIBS='-lws2_32'
    $(MAKE) -C '$(1)/build/$(TARGET)/libgomp' -j '$(JOBS)' install
endef
