# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libcint
$(PKG)_WEBSITE  := https://github.com/sunqm/libcint
$(PKG)_DESCR    := General GTO integrals for quantum chemistry
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.14
$(PKG)_CHECKSUM := 2952d59203f011680c2039ddb1d7337cd669b12632386496ce2ba2afdafbfcad
$(PKG)_GH_CONF  := sunqm/libcint/tags,v
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc blas

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBLAS_LIBRARIES="-lblas -lgfortran -lquadmath"
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
