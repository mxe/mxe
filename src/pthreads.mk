# pthreads-w32
# http://sourceware.org/pthreads-win32/

PKG            := pthreads
$(PKG)_VERSION := 2-8-0
$(PKG)_SUBDIR  := pthreads-w32-$($(PKG)_VERSION)-release
$(PKG)_FILE    := pthreads-w32-$($(PKG)_VERSION)-release.tar.gz
$(PKG)_URL     := ftp://sourceware.org/pub/pthreads-win32/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc

define $(PKG)_UPDATE
    wget -q -O- 'ftp://sourceware.org/pub/pthreads-win32/Release_notes' | \
    $(SED) -n 's,^RELEASE \([0-9][^[:space:]]*\).*,\1,p' | \
        tr '.' '-' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) '35i\#define PTW32_STATIC_LIB' -i '$(2)/pthread.h'
    $(MAKE) -C '$(2)' -j '$(JOBS)' GC-static CROSS='$(TARGET)-'
    install -d '$(PREFIX)/$(TARGET)/lib'
    install -m664 '$(2)/libpthreadGC2.a' '$(PREFIX)/$(TARGET)/lib/libpthread.a'
    install -d '$(PREFIX)/$(TARGET)/include'
    install -m664 '$(2)/pthread.h' '$(2)/sched.h' '$(2)/semaphore.h' '$(PREFIX)/$(TARGET)/include/'
endef
