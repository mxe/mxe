# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libcint
$(PKG)_WEBSITE  := https://github.com/sunqm/libcint
$(PKG)_DESCR    := General GTO integrals for quantum chemistry
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.13
$(PKG)_CHECKSUM := ee64f0bc7fb6073063ac3c9bbef8951feada141e197b1a5cc389c8cccf8dc360
$(PKG)_GH_CONF  := sunqm/libcint/tags,v
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc blas

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBLAS_LIBRARIES="-lblas -lgfortran -lquadmath"
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
