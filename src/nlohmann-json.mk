# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := nlohmann-json
$(PKG)_WEBSITE  := https://json.nlohmann.me/
$(PKG)_DESCR    := JSON for Modern C++
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.11.3
$(PKG)_CHECKSUM := 0d8ef5af7f9794e3263480193c491549b2ba6cc74bb018906202ada498a79406
$(PKG)_SUBDIR   := json-$($(PKG)_VERSION)
$(PKG)_FILE     := v$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/nlohmann/json/archive/refs/tags/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/nlohmann/json/tags' | \
		grep '<a .*href="/nlohmann/json/archive/refs/tags/' | \
		$(SED) -n 's,.*href="/nlohmann/json/archive/refs/tags/v\([0-9][^"_]*\)\.tar.*,\1,p' | \
		head -1
endef

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_TESTING=OFF \
		-DJSON_32bitTest=OFF \
		-DJSON_BuildTests=OFF \
		-DJSON_Install=ON
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $($(PKG)_DESCR)'; \
    ) > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # compile test
    '$(TARGET)-g++' \
        -W -Wall -Werror \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
