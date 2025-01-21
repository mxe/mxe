# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mman-win32
$(PKG)_WEBSITE  := https://code.google.com/p/mman-win32/
$(PKG)_DESCR    := MMA-Win32
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2d1c576
$(PKG)_CHECKSUM := b9b7a4afdf19644b761bd66a7a0fba5cea4bdf2cba180bd9323a6029f134ccbe
$(PKG)_GH_CONF  := alitrack/mman-win32/branches/master
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_TESTS=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' -W -Wall \
        '$(SOURCE_DIR)/test.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        -lmman
endef
