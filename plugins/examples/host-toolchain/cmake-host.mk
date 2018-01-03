# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cmake-host
$(PKG)_IGNORE    = $(cmake_IGNORE)
$(PKG)_VERSION   = $(cmake_VERSION)
$(PKG)_CHECKSUM  = $(cmake_CHECKSUM)
$(PKG)_SUBDIR    = $(cmake_SUBDIR)
$(PKG)_FILE      = $(cmake_FILE)
$(PKG)_URL       = $(cmake_URL)
$(PKG)_URL_2     = $(cmake_URL_2)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    echo $(cmake_VERSION)
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS) VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
