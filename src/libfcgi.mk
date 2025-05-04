# This file is part of MXE.
# See index.html for further information.

PKG             := libfcgi
$(PKG)_WEBSITE  := https://github.com/FastCGI-Archives
$(PKG)_DESCR    := FastCGI
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.6
$(PKG)_CHECKSUM := 39af4fb21a6d695a5f0b1c4fa95776d2725f6bc6c77680943a2ab314acd505c1
$(PKG)_GH_CONF  := FastCGI-Archives/fcgi2/tags
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        CFLAGS='-Wno-incompatible-pointer-types'

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)

    # Test
    '$(TARGET)-g++' \
        -W -Wall -Werror -std=c++0x -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' fcgi --cflags --libs` -lws2_32
endef
