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
        '$(TOP_DIR)/src/pthreads-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-pthreads.exe' \
        `'$(TARGET)-pkg-config' --libs pthreads`

    # test cmake
    mkdir '$(1).cmake'
    (echo 'find_package(Threads REQUIRED)'; \
     echo 'add_executable(test-pthreads-cmake $(PREFIX)/../src/pthreads-test.c)'; \
     echo 'target_link_libraries(test-pthreads-cmake $${CMAKE_THREAD_LIBS_INIT})'; \
     echo 'install(TARGETS test-pthreads-cmake DESTINATION bin)'; \
    ) > '$(1).cmake/CMakeLists.txt'

    cd '$(1).cmake' && '$(TARGET)-cmake' .
    $(MAKE) -C '$(1).cmake' -j 1 install
endef
