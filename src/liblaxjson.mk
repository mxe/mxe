# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := liblaxjson
$(PKG)_WEBSITE  := https://github.com/andrewrk/liblaxjson
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.5
$(PKG)_CHECKSUM := ffc495b5837e703b13af3f5a5790365dc3a6794f12f0fa93fb8593b162b0b762
$(PKG)_GH_CONF  := andrewrk/liblaxjson/tags
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)'

    '$(TARGET)-cmake' --build '$(BUILD_DIR)' -- -j '$(JOBS)'

    '$(TARGET)-cmake' \
        -DCMAKE_INSTALL_COMPONENT=$(if $(BUILD_STATIC),static,shared)-lib \
        -P '$(BUILD_DIR)/cmake_install.cmake'
    '$(TARGET)-cmake' \
        -DCMAKE_INSTALL_COMPONENT=header \
        -P '$(BUILD_DIR)/cmake_install.cmake'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic -std=c99 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-liblaxjson.exe' \
        -llaxjson
endef
