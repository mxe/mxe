# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cmake
$(PKG)_WEBSITE  := https://www.cmake.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.4.4
$(PKG)_CHECKSUM := bd24c30d80a7744ae84b845ff080cc8453b06c622ef01066564108e9cefc44cf
$(PKG)_SUBDIR   := cmake-$($(PKG)_VERSION)
$(PKG)_FILE     := cmake-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.cmake.org/files/v$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 'NOTE: Please ensure all cmake packages build after updating with:' >&2;
    echo '    make `make show-downstream-deps-cmake` MXE_TARGETS="$(MXE_TARGET_LIST)"' >&2;
    echo '' >&2;
    $(WGET) -q -O- 'https://www.cmake.org/cmake/resources/software.html' | \
    $(SED) -n 's,.*cmake-\(4[0-9.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD_$(BUILD)
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --parallel='$(JOBS)' \
        $(PKG_CONFIGURE_OPTS) \
	CFLAGS='-Wno-implicit-function-declaration -Wno-int-conversion'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
