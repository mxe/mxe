# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Pthreads-w32
PKG             := pthreads
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2-8-0
$(PKG)_CHECKSUM := da8371cb20e8e238f96a1d0651212f154d84a9ac
$(PKG)_SUBDIR   := pthreads-w32-$($(PKG)_VERSION)-release
$(PKG)_FILE     := pthreads-w32-$($(PKG)_VERSION)-release.tar.gz
$(PKG)_WEBSITE  := http://sourceware.org/pthreads-win32/
$(PKG)_URL      := ftp://sourceware.org/pub/pthreads-win32/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'ftp://sourceware.org/pub/pthreads-win32/Release_notes' | \
    $(SED) -n 's,^RELEASE \([0-9][^[:space:]]*\).*,\1,p' | \
    tr '.' '-' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i '35i\#define PTW32_STATIC_LIB' '$(1)/pthread.h'
    $(SED) -i '41i\#define PTW32_STATIC_LIB' '$(1)/sched.h'
    $(SED) -i '41i\#define PTW32_STATIC_LIB' '$(1)/semaphore.h'
    $(SED) -i 's,#include "config.h",,'      '$(1)/pthread.h'
    $(MAKE) -C '$(1)' -j 1 GC-static CROSS='$(TARGET)-'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libpthreadGC2.a' '$(PREFIX)/$(TARGET)/lib/libpthread.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/pthread.h'   '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/sched.h'     '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/semaphore.h' '$(PREFIX)/$(TARGET)/include/'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-pthreads.exe' \
        -lpthread -lws2_32
endef
