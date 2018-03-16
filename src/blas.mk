# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := blas
$(PKG)_WEBSITE  := http://www.netlib.org/blas/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.8.0
$(PKG)_CHECKSUM := a8ce4930cfc695a7c09118060f5f2aa3601130e5265b2f4572c0984d5f282e49
$(PKG)_SUBDIR   := lapack-release-lapack-$($(PKG)_VERSION)
$(PKG)_FILE     := lapack-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/Reference-LAPACK/lapack-release/archive/lapack-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    echo 1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMAKE_AR='$(PREFIX)/bin/$(TARGET)-ar' \
        -DCMAKE_RANLIB='$(PREFIX)/bin/$(TARGET)-ranlib'
    $(MAKE) -C '$(BUILD_DIR)/BLAS' -j '$(JOBS)' install
endef
