# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := lz4
$(PKG)_WEBSITE  := https://github.com/$(PKG)/$(PKG)
$(PKG)_DESCR    := lossless compression algorithm optimized for speed
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.3
$(PKG)_CHECKSUM := 030644df4611007ff7dc962d981f390361e6c97a34e5cbc393ddfbe019ffe2c1
$(PKG)_GH_CONF  := lz4/lz4/tags,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
        -DCMAKE_INSTALL_BINDIR=$(BUILD_DIR)/null \
        -DCMAKE_INSTALL_MANDIR=$(BUILD_DIR)/null \
        '$(SOURCE_DIR)/build/cmake'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
    $(if $(BUILD_SHARED), $(INSTALL) '$(BUILD_DIR)/liblz4.dll' '$(PREFIX)/$(TARGET)/bin/')

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' lib$(PKG) --cflags --libs`
endef
