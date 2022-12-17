# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := minizip
$(PKG)_WEBSITE  := https://www.winimage.com/zLibDll/minizip.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.1
$(PKG)_CHECKSUM := 96c95b274dd535984ce0e87691691388f2b976106e8cf8d527b15da552ac94e4
$(PKG)_GH_CONF  := zlib-ng/minizip-ng/releases
$(PKG)_DEPS     := cc bzip2 zlib openssl

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_TEST=OFF \
        -DUSE_ZLIB=ON

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -Wno-format \
        -DHAVE_STDINT_H -DHAVE_INTTYPES_H \
        '$(SOURCE_DIR)/minizip.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --libs-only-l`
endef
