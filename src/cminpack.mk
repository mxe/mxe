# This file is part of MXE.
# See index.html for further information.

PKG             := cminpack
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.4
$(PKG)_CHECKSUM := 3b517bf7dca68cc9a882883db96dac0a0d37d72aba6dfb0c9c7e78e67af503ca
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://devernay.free.fr/hacks/cminpack/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://devernay.free.fr/hacks/cminpack/index.html' | \
    $(SED) -n 's,.*cminpack-\([0-9.]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    '$(TARGET)-cmake' -B'$(BUILD_DIR)' -H'$(SOURCE_DIR)' \
        -DBUILD_EXAMPLES=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
