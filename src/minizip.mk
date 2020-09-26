# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := minizip
$(PKG)_WEBSITE  := https://www.winimage.com/zLibDll/minizip.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.10.0
$(PKG)_CHECKSUM := 4c7f236268fef57ce5dcbd9645235a22890d62480a592e1b0515ecff93f9989b
$(PKG)_GH_CONF  := nmoinvaz/minizip/releases
$(PKG)_DEPS     := cc bzip2 zlib

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DMZ_BUILD_TEST=OFF \
        -DMZ_ZLIB=ON \
        -DMZ_ZSTD=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror \
        -DHAVE_STDINT_H -DHAVE_INTTYPES_H \
        '$(SOURCE_DIR)/minizip.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --libs-only-l`
endef
