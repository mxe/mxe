# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ms-gsl
$(PKG)_WEBSITE  := https://github.com/microsoft/gsl
$(PKG)_DESCR    := guidelines support library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.0
$(PKG)_CHECKSUM := d3234d7f94cea4389e3ca70619b82e8fb4c2f33bb3a070799f1e18eef500a083
$(PKG)_GH_CONF  := microsoft/gsl/releases,v
$(PKG)_DEPS     := cc 
$(PKG)_SUBDIR   := GSL-$($(PKG)_VERSION)

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$1/build' && '$(TARGET)-cmake' -DGSL_TEST=0 .. 
    $(MAKE) -C '$(1)/build' -j $(JOBS) install
endef
