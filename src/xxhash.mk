# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xxhash
$(PKG)_WEBSITE  := https://cyan4973.github.io/xxHash/
$(PKG)_DESCR    := xxHash
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.7.2
$(PKG)_CHECKSUM := 7e93d28e81c3e95ff07674a400001d0cdf23b7842d49b211e5582d00d8e3ac3e
$(PKG)_GH_CONF  := Cyan4973/xxHash/tags,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)/cmake_unofficial'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # create pkg-config files
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: xxHash'; \
     echo 'Libs: -lxxhash';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
