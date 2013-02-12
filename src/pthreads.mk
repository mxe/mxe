# This file is part of MXE.
# See index.html for further information.

# runtimes can/will have different implementations
# but the pre-requisite package and test are the same
PKG             := pthreads
$(PKG)_DEPS     := pthreads-w32 winpthreads

define $(PKG)_UPDATE
    echo $(pthreads_VERSION)
endef

PTHREADS_TEST = \
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TOP_DIR)/src/pthreads-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        -lpthread -lws2_32
