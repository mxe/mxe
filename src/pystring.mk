# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pystring
$(PKG)_WEBSITE  := https://github.com/imageworks/pystring
$(PKG)_DESCR    := Header-only C++ string library inspired by Python
$(PKG)_VERSION  := 1.1.4
$(PKG)_CHECKSUM := 49da0fe2a049340d3c45cce530df63a2278af936003642330287b68cefd788fb
$(PKG)_GH_CONF  := imageworks/pystring/tags,v
$(PKG)_SUBDIR   := pystring-$($(PKG)_VERSION)
$(PKG)_TARGETS  := $(TARGET)
$(PKG)_DEPS     :=

define $(PKG)_BUILD
    # Workaround for pystring v1.1.4: upstream CMake install target does not include the public header file.
    # Install it manually so consumers of the library can include it.
    mkdir -p '$(PREFIX)/$(TARGET)/include/pystring'
    cp '$(SOURCE_DIR)/pystring.h' '$(PREFIX)/$(TARGET)/include/pystring/'

    # Configure the build with CMake.
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_SHARED_LIBS=OFF \
        -DPYSTRING_HEADER_ONLY=1 \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)'

    # Build and install
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' install

    # compile test executable (pystring does not provice .pc file)
    '$(TARGET)-g++' \
        '$(TEST_FILE)' \
        -I '$(PREFIX)/$(TARGET)/include' \
        -L '$(PREFIX)/$(TARGET)/lib' \
        -lpystring \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe'
endef
