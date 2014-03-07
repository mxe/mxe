# This file is part of MXE.
# See index.html for further information.

PKG             := pthreads-w32
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2-9-1
$(PKG)_CHECKSUM := 24d40e89c2e66a765733e8c98d6f94500343da86
$(PKG)_SUBDIR   := pthreads-w32-$($(PKG)_VERSION)-release
$(PKG)_FILE     := pthreads-w32-$($(PKG)_VERSION)-release.tar.gz
$(PKG)_URL      := ftp://sourceware.org/pub/pthreads-win32/$($(PKG)_FILE)
$(PKG)_DEPS     :=

$(PKG)_DEPS_i686-pc-mingw32 := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://sourceware.org/pub/pthreads-win32/dll-latest/include/pthread.h' | \
    $(SED) -n 's/^#define PTW32_VERSION \([^,]*\),\([^,]*\),\([^,]*\),.*/\1-\2-\3/p;'
endef

define $(PKG)_BUILD_i686-pc-mingw32
    $(MAKE) -C '$(1)' -j 1 \
        $(if $(BUILD_STATIC),GC-static,GC-inlined) \
        CROSS='$(TARGET)-'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    # This is the DLL include lib on a shared build
    $(INSTALL) -m644 '$(1)/libpthreadGC2.a' '$(PREFIX)/$(TARGET)/lib/libpthread.a'
    $(if $(BUILD_STATIC), \
        $(SED) -i 's/defined(PTW32_STATIC_LIB)/1/' '$(1)/pthread.h' '$(1)/sched.h' '$(1)/semaphore.h',
        $(INSTALL) -m644 '$(1)/pthreadGC2.dll'  '$(PREFIX)/$(TARGET)/bin/pthread.dll')
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/pthread.h'   '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/sched.h'     '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/semaphore.h' '$(PREFIX)/$(TARGET)/include/'

    $(PTHREADS_TEST)
endef
