# This file is part of MXE.
# See index.html for further information.

# Runtimes can/will have different implementations,
# but the pre-requisite package and test are the same.

PKG             := pthreads
$(PKG)_VERSION  := POSIX 1003.1-2001
$(PKG)_DEPS     := winpthreads

define $(PKG)_UPDATE
    echo $(pthreads_VERSION)
endef

define PTHREADS_TEST
    # install and test pkg-config
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: pthreads'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: Posix Threads ($(PKG))'; \
     echo 'Libs: -lpthread'; \
    ) > '$(PREFIX)/$(TARGET)/lib/pkgconfig/pthreads.pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TOP_DIR)/src/pthreads-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' --libs pthreads`

    # test cmake
    mkdir '$(1).test-cmake'
    cd '$(1).test-cmake' && '$(TARGET)-cmake' \
        -DPKG=$(PKG) \
        '$(PWD)/src/cmake/test'
    $(MAKE) -C '$(1).test-cmake' -j 1 install
endef
