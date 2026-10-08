# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libcint
$(PKG)_WEBSITE  := https://github.com/sunqm/libcint
$(PKG)_DESCR    := General GTO integrals for quantum chemistry
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.1.3
$(PKG)_CHECKSUM := e4d977d4aeb4d5b87639ea57a2d2f1d5c1001f3f94e480b08c297a6cbc186f27
$(PKG)_GH_CONF  := sunqm/libcint/tags,v
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc blas

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBLAS_LIBRARIES="-lblas -lgfortran -lquadmath"
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
