# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libatomic_ops
$(PKG)_WEBSITE  := https://github.com/ivmai/libatomic_ops
$(PKG)_DESCR    := The atomic_ops project (Atomic memory update operations portable implementation)
$(PKG)_IGNORE   := 7.6%
$(PKG)_VERSION  := 7.4.8
$(PKG)_CHECKSUM := b985816abc69df5781d6d9fcf081e03a3a1e44032030d0a2c28f8de731e7f20f
$(PKG)_GH_CONF  := ivmai/libatomic_ops/tags,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    # build and install the library
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # create pkg-config file
    # the *_gpl lib has extra functions needed for test program
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: atomic_ops_gpl'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $($(PKG)_DESCR)'; \
     echo 'Requires: atomic_ops'; \
     echo 'Libs: -latomic_ops_gpl';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/atomic_ops_gpl.pc'

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -pedantic -std=c99 \
        '$(SOURCE_DIR)/tests/test_stack.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' atomic_ops_gpl --cflags --libs`
endef
