# This file is part of MXE.
# See index.html for further information.

PKG             := pthreads
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 24d40e89c2e66a765733e8c98d6f94500343da86
$(PKG)_SUBDIR   := pthreads-w32-$($(PKG)_VERSION)-release
$(PKG)_FILE     := pthreads-w32-$($(PKG)_VERSION)-release.tar.gz
$(PKG)_URL      := ftp://sourceware.org/pub/pthreads-win32/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://sourceware.org/pub/pthreads-win32/dll-latest/include/pthread.h' | \
    $(SED) -n 's/^#define PTW32_VERSION \([^,]*\),\([^,]*\),\([^,]*\),.*/\1-\2-\3/p;'
endef

define $(PKG)_BUILD
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
