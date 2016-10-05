# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := hyperscan
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.3.1
$(PKG)_CHECKSUM := a7bce1287c06d53d1fb34266d024331a92ee24cbb2a7a75061b4ae50a30bae97
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/01org/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc boost
# $(PKG)_NATIVE_DEPS := ragel

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, 01org/hyperscan, v)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    # Add the following options to run on (virtual) machine without AVX2
    # -DCMAKE_C_FLAGS="-march=core2" -DCMAKE_CXX_FLAGS="-march=core2"
    cd '$(1).build' && '$(TARGET)-cmake' \
        -DBUILD_SHARED_LIBS=$(if $(BUILD_STATIC),OFF,ON) \
        -DRAGEL='$(PREFIX)/$(BUILD)/bin/ragel' \
        '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install

    '$(TARGET)-gcc' \
        '$(1)/examples/simplegrep.c' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config --cflags --libs libhs`
endef
