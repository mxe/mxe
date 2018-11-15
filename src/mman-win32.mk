# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mman-win32
$(PKG)_WEBSITE  := https://code.google.com/p/mman-win32/
$(PKG)_DESCR    := MMA-Win32
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9f115ad
$(PKG)_CHECKSUM := 8ef745c80ab2b0ea52eba4830c45b20926fd9dcbc16c3da31f66607316dd7751
$(PKG)_GH_CONF  := witwall/mman-win32/branches/master
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_TESTS=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' -W -Wall \
        '$(1)/test.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        -lmman
endef
