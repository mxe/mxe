# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xxhash
$(PKG)_WEBSITE  := https://cyan4973.github.io/xxHash/
$(PKG)_DESCR    := xxHash
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.6.4
$(PKG)_CHECKSUM := 4570ccd111df6b6386502791397906bf69b7371eb209af7d41debc2f074cdb22
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
