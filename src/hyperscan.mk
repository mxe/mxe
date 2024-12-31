# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := hyperscan
$(PKG)_WEBSITE  := https://www.hyperscan.io/
$(PKG)_DESCR    := Hyperscan
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.4.2
$(PKG)_CHECKSUM := 32b0f24b3113bbc46b6bfaa05cf7cf45840b6b59333d078cc1f624e4c40b2b99
$(PKG)_GH_CONF  := 01org/hyperscan/tags, v
$(PKG)_DEPS     := cc boost $(BUILD)~ragel

# Add the following options to run on (virtual) machine without AVX2 or
# build on machine where native detection of SSSE3 may fail
# -DCMAKE_C_FLAGS="-march=core2" -DCMAKE_CXX_FLAGS="-march=core2"

$(PKG)_ARCH_FLAGS = \
    $(TARGET)-gcc -xc /dev/null -o- -S -fverbose-asm \
        -march=native | \
        grep mssse3 >/dev/null 2>&1 || \
        echo -march=core2

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
        -DRAGEL='$(PREFIX)/$(BUILD)/bin/ragel' \
        -DCMAKE_C_FLAGS="`$($(PKG)_ARCH_FLAGS)`" \
        -DCMAKE_CXX_FLAGS="`$($(PKG)_ARCH_FLAGS)`" \
        '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        '$(1)/examples/simplegrep.c' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config --cflags --libs libhs`
endef
