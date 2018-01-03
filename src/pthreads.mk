# This file is part of MXE. See LICENSE.md for licensing information.

# Runtimes can/will have different implementations,
# but the pre-requisite package and test are the same.

PKG             := pthreads
$(PKG)_WEBSITE  := https://en.wikipedia.org/wiki/POSIX_Threads
$(PKG)_DESCR    := POSIX Threads
$(PKG)_VERSION  := POSIX 1003.1-2001
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    # install and test pkg-config
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: pthreads'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: Posix Threads ($(PKG))'; \
     echo 'Libs: -lpthread'; \
    ) > '$(PREFIX)/$(TARGET)/lib/pkgconfig/pthreads.pc'

    # test pkg-config and libgomp
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TOP_DIR)/src/$(PKG)-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' --libs pthreads`

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TOP_DIR)/src/$(PKG)-libgomp-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG)-libgomp.exe' \
        -fopenmp

    # test cmake
    mkdir '$(1).test-cmake'
    cd '$(1).test-cmake' && '$(TARGET)-cmake' \
        -DPKG=$(PKG) \
        '$(PWD)/src/cmake/test'
    $(MAKE) -C '$(1).test-cmake' -j 1 install
endef
