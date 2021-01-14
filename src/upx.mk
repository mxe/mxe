# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := upx
$(PKG)_WEBSITE  := https://upx.github.io/
$(PKG)_DESCR    := UPX
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.96
$(PKG)_CHECKSUM := 47774df5c958f2868ef550fb258b97c73272cb1f44fe776b798e393465993714
$(PKG)_GH_CONF  := upx/upx/releases/latest,v,,,,.tar.xz
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)-src
$(PKG)_DEPS     := cc ucl zlib
$(PKG)_DEPS_$(BUILD) := ucl zlib
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

define $(PKG)_BUILD
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)' all \
        CXX='$(TARGET)-g++' \
        CC='$(TARGET)-gcc' \
        LD='$(TARGET)-ld' \
        AR='$(TARGET)-ar' \
        CHECK_WHITESPACE= \
        exeext='.exe'
    cp '$(SOURCE_DIR)/src/upx.exe' '$(PREFIX)/$(TARGET)/bin/'
endef

define $(PKG)_BUILD_$(BUILD)
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)' all \
        CXX='$(BUILD_CXX)' \
        CC='$(BUILD_CC)' \
        LIBS='-L$(PREFIX)/$(BUILD)/lib -lucl -lz' \
        UPX_UCLDIR='$(PREFIX)/$(TARGET)' \
        CHECK_WHITESPACE= \
        exeext=
    cp '$(SOURCE_DIR)/src/upx' '$(PREFIX)/$(TARGET)/bin/'
endef
