# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libqrencode
$(PKG)_WEBSITE  := https://fukuchi.org/works/qrencode/
$(PKG)_DESCR    := a fast and compact QR Code encoding library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0.0
$(PKG)_CHECKSUM := c2c8a8110354463a3332cb48abf8581c8d94136af4dc1418f891cc9c7719e3c1
$(PKG)_GH_CONF  := fukuchi/libqrencode/tags,v
$(PKG)_DEPS     := cc pthreads

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DWITH_TESTS=OFF \
        -DWITH_TOOLS=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -pedantic \
        '$(SOURCE_DIR)/tests/prof_qrencode.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
