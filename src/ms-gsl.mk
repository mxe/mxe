# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ms-gsl
$(PKG)_WEBSITE  := https://github.com/microsoft/gsl
$(PKG)_DESCR    := guidelines support library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2.0
$(PKG)_CHECKSUM := 2c717545a073649126cb99ebd493fa2ae23120077968795d2c69cbab821e4ac6
$(PKG)_GH_CONF  := microsoft/gsl/releases,v
$(PKG)_DEPS     := cc
$(PKG)_SUBDIR   := GSL-$($(PKG)_VERSION)

define $(PKG)_BUILD
    '$(TARGET)-cmake' -S $(SOURCE_DIR) -B $(BUILD_DIR) -DGSL_TEST=0
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' install
endef
