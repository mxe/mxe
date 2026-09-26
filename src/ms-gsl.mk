# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ms-gsl
$(PKG)_WEBSITE  := https://github.com/microsoft/gsl
$(PKG)_DESCR    := guidelines support library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.0.1
$(PKG)_CHECKSUM := 733a87a7eea56db075ee060735ba7616a27c1c55955f264d5473bf9e83294ad0
$(PKG)_GH_CONF  := microsoft/gsl/releases,v
$(PKG)_DEPS     := cc
$(PKG)_SUBDIR   := GSL-$($(PKG)_VERSION)

define $(PKG)_BUILD
    '$(TARGET)-cmake' -S $(SOURCE_DIR) -B $(BUILD_DIR) -DGSL_TEST=0
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' install
endef
