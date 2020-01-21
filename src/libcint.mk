# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libcint
$(PKG)_WEBSITE  := https://github.com/sunqm/libcint
$(PKG)_DESCR    := General GTO integrals for quantum chemistry
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.18
$(PKG)_CHECKSUM := c5ecc295f912fd9b80f41c353286172e710ed52ce825d1255d25a0388b6c8ffe
$(PKG)_GH_CONF  := sunqm/libcint/tags,v
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc blas

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBLAS_LIBRARIES="-lblas -lgfortran -lquadmath"
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
