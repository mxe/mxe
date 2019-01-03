# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xxhash
$(PKG)_WEBSITE  := https://cyan4973.github.io/xxHash/
$(PKG)_DESCR    := xxHash
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.6.5
$(PKG)_CHECKSUM := 19030315f4fc1b4b2cdb9d7a317069a109f90e39d1fe4c9159b7aaa39030eb95
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
