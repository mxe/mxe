# This file is part of MXE. See LICENSE.md for licensing information.

PKG              := openexr
$(PKG)_WEBSITE   := https://www.openexr.com/
$(PKG)_DESCR     := OpenEXR
$(PKG)_IGNORE    = $(ilmbase_IGNORE)
$(PKG)_VERSION   = $(ilmbase_VERSION)
$(PKG)_CHECKSUM  = $(ilmbase_CHECKSUM)
$(PKG)_SUBDIR    = openexr-$($(PKG)_VERSION)
$(PKG)_FILE      = $(ilmbase_FILE)
$(PKG)_URL       = $(ilmbase_URL)
$(PKG)_DEPS      = cc ilmbase pthreads zlib $(BUILD)~cmake
$(PKG)_PATCHES   = $(ilmbase_PATCHES)

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
        -DOPENEXR_CXX_STANDARD=11 \
        -DOPENEXR_INSTALL_PKG_CONFIG=ON \
        -DBUILD_TESTING=OFF \
        "$(SOURCE_DIR)/OpenEXR"
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-g++' \
        -Wall -Wextra -std=c++11 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-openexr.exe' \
        `'$(TARGET)-pkg-config' OpenEXR --cflags --libs`
endef