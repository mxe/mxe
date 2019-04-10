# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libqrencode
$(PKG)_WEBSITE  := https://fukuchi.org/works/qrencode/
$(PKG)_DESCR    := a fast and compact QR Code encoding library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0.2
$(PKG)_CHECKSUM := 43091fea4752101f0fe61a957310ead10a7cb4b81e170ce61e5baa73a6291ac2
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
