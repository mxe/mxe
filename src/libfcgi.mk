# This file is part of MXE.
# See index.html for further information.

PKG             := libfcgi
$(PKG)_WEBSITE  := https://github.com/FastCGI-Archives
$(PKG)_DESCR    := FastCGI
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := a6ad89b
$(PKG)_CHECKSUM := c6ced2e940f662adc337a5e5dd74e3a13d7e14687d9cb71fe9c4185f36d2e57f
$(PKG)_GH_CONF  := FastCGI-Archives/fcgi2/branches/master
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)

    # Test
    '$(TARGET)-g++' \
        -W -Wall -Werror -std=c++0x -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' fcgi --cflags --libs` -lws2_32
endef
