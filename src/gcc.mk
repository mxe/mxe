# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GCC
PKG             := gcc
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 4.5.0
$(PKG)_CHECKSUM := 4beb8366ce1883f37255aa57f0258e7d3cd13a9b
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://gcc.gnu.org/
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.cs.tu-berlin.de/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := mingwrt mingwrt-dll w32api binutils gcc-gmp gcc-mpc gcc-mpfr gcc-pthreads

define $(PKG)_UPDATE
    wget -q -O- 'http://ftp.gnu.org/gnu/gcc/?C=M;O=D' | \
    grep '<a href="gcc-' | \
    $(SED) -n 's,.*<a href="gcc-\([0-9][^"]*\)/".*,\1,p' | \
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
    # unpack support libraries
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-gmp)
    mv '$(1)/$(gcc-gmp_SUBDIR)' '$(1)/gmp'
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-mpc)
    mv '$(1)/$(gcc-mpc_SUBDIR)' '$(1)/mpc'
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
    $(SED) -i '35i\#define PTW32_STATIC_LIB' '$(1)/$(gcc-pthreads_SUBDIR)/pthread.h'
    $(SED) -i '41i\#define PTW32_STATIC_LIB' '$(1)/$(gcc-pthreads_SUBDIR)/sched.h'
    $(SED) -i '41i\#define PTW32_STATIC_LIB' '$(1)/$(gcc-pthreads_SUBDIR)/semaphore.h'
    $(SED) -i 's,#include "config.h",,'      '$(1)/$(gcc-pthreads_SUBDIR)/pthread.h'
    $(MAKE) -C '$(1)/$(gcc-pthreads_SUBDIR)' -j 1 GC-static CROSS='$(TARGET)-'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m664 '$(1)/$(gcc-pthreads_SUBDIR)/libpthreadGC2.a' '$(PREFIX)/$(TARGET)/lib/libpthread.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m664 '$(1)/$(gcc-pthreads_SUBDIR)/pthread.h'   '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m664 '$(1)/$(gcc-pthreads_SUBDIR)/sched.h'     '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m664 '$(1)/$(gcc-pthreads_SUBDIR)/semaphore.h' '$(PREFIX)/$(TARGET)/include/'
    # build libgomp
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/libgomp/configure'
    mkdir '$(1)/build/$(TARGET)/libgomp'
    cd    '$(1)/build/$(TARGET)/libgomp' && '$(1)/libgomp/configure' \
        $(gcc_CONFIGURE_OPTIONS) \
        --host='$(TARGET)' \
        LIBS='-lws2_32'
    $(MAKE) -C '$(1)/build/$(TARGET)/libgomp' -j '$(JOBS)' install

    # create pkg-config script
    (echo '#!/bin/sh'; \
     echo 'PKG_CONFIG_PATH= PKG_CONFIG_LIBDIR='\''$(PREFIX)/$(TARGET)/lib/pkgconfig'\'' exec pkg-config --static "$$@"') \
             > '$(PREFIX)/bin/$(TARGET)-pkg-config'
    chmod 0755 '$(PREFIX)/bin/$(TARGET)-pkg-config'
endef
