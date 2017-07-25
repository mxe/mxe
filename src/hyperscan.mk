# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := hyperscan
$(PKG)_WEBSITE  := https://01.org/hyperscan
$(PKG)_DESCR    := Hyperscan
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.3.2
$(PKG)_CHECKSUM := 6cd5820d6da51d6fe4ab12066d1efd9afecc1bc6fb7d6eca9c98f76fd391dbd5
$(PKG)_GH_CONF  := 01org/hyperscan, v
$(PKG)_DEPS     := gcc boost
# $(PKG)_NATIVE_DEPS := ragel

define $(PKG)_BUILD
    # Add the following options to run on (virtual) machine without AVX2
    # -DCMAKE_C_FLAGS="-march=core2" -DCMAKE_CXX_FLAGS="-march=core2"
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
        -DRAGEL='$(PREFIX)/$(BUILD)/bin/ragel' \
        -DMXE_DISABLE_INCLUDE_SYSTEM_FLAG=TRUE \
        '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        '$(1)/examples/simplegrep.c' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config --cflags --libs libhs`
endef
