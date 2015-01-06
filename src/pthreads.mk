# This file is part of MXE.
# See index.html for further information.

# Runtimes can/will have different implementations,
# but the pre-requisite package and test are the same.

PKG             := pthreads
$(PKG)_VERSION  := POSIX 1003.1-2001
$(PKG)_CHECKSUM  = $(winpthreads_CHECKSUM)
$(PKG)_FILE      = $(winpthreads_FILE)
$(PKG)_DEPS     := winpthreads

define $(PKG)_UPDATE
    echo $(pthreads_VERSION)
endef

PTHREADS_TEST = \
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig' && \
    (echo 'Name: pthreads'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: Posix Threads ($(PKG))'; \
     echo 'Libs: -lpthread -lws2_32';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/pthreads.pc' && \
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TOP_DIR)/src/pthreads-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-pthreads.exe' \
        `'$(TARGET)-pkg-config' --libs pthreads`
