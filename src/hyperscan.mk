# This file is part of MXE.
# See index.html for further information.

PKG             := hyperscan
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2.0
$(PKG)_CHECKSUM := d06d8f31a62e5d2903a8ccf07696e02cadf4de2024dc3b558d410d913c81dbef
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/01org/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc boost

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, 01org/hyperscan, v)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    # Add the following options to run on (virtual) machine without AVX2
    # -DCMAKE_C_FLAGS="-march=core2" -DCMAKE_CXX_FLAGS="-march=core2"
    cd '$(1).build' && '$(TARGET)-cmake' \
        -DBUILD_SHARED_LIBS=$(if $(BUILD_STATIC),OFF,ON) \
        '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install

    '$(TARGET)-gcc' \
        '$(1)/examples/simplegrep.c' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config --cflags --libs libhs`
endef
