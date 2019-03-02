# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := lz4
$(PKG)_WEBSITE  := https://github.com/$(PKG)/$(PKG)
$(PKG)_DESCR    := lossless compression algorithm optimized for speed
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.3
$(PKG)_CHECKSUM := 33af5936ac06536805f9745e0b6d61da606a1f8b4cc5c04dd3cbaca3b9b4fc43
$(PKG)_GH_CONF  := lz4/lz4/tags,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
        -DCMAKE_INSTALL_BINDIR=$(BUILD_DIR)/null \
        -DCMAKE_INSTALL_MANDIR=$(BUILD_DIR)/null \
        '$(SOURCE_DIR)/contrib/cmake_unofficial'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
    $(if $(BUILD_SHARED), $(INSTALL) '$(BUILD_DIR)/liblz4.dll' '$(PREFIX)/$(TARGET)/bin/')

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' lib$(PKG) --cflags --libs`
endef
