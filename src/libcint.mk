# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libcint
$(PKG)_WEBSITE  := https://github.com/sunqm/libcint
$(PKG)_DESCR    := General GTO integrals for quantum chemistry
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.6
$(PKG)_CHECKSUM := a7d6d46de9be044409270b27727a1d620d21b5fda6aa7291548938e1ced25404
$(PKG)_GH_CONF  := sunqm/libcint/tags,v
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc blas

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBLAS_LIBRARIES="-lblas -lgfortran -lquadmath"
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
