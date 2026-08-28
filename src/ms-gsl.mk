# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ms-gsl
$(PKG)_WEBSITE  := https://github.com/microsoft/gsl
$(PKG)_DESCR    := guidelines support library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.0.0
$(PKG)_CHECKSUM := e646da6ac00a885cfae33dc935e52bb42bd1d05e41b8437cbc25ca3d74930f35
$(PKG)_GH_CONF  := microsoft/gsl/releases,v
$(PKG)_DEPS     := cc
$(PKG)_SUBDIR   := GSL-$($(PKG)_VERSION)

define $(PKG)_BUILD
    '$(TARGET)-cmake' -S $(SOURCE_DIR) -B $(BUILD_DIR) -DGSL_TEST=0
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' install
endef
