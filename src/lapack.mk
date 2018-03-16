# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := lapack
$(PKG)_WEBSITE  := http://www.netlib.org/lapack/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.8.0
$(PKG)_CHECKSUM := a8ce4930cfc695a7c09118060f5f2aa3601130e5265b2f4572c0984d5f282e49
$(PKG)_SUBDIR   := lapack-release-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/Reference-LAPACK/lapack-release/archive/$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc cblas

define $(PKG)_UPDATE
    echo 1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMAKE_AR='$(PREFIX)/bin/$(TARGET)-ar' \
        -DCMAKE_RANLIB='$(PREFIX)/bin/$(TARGET)-ranlib' \
        -DLAPACKE=ON
    $(MAKE) -C '$(BUILD_DIR)/SRC'     -j '$(JOBS)' install
    $(MAKE) -C '$(BUILD_DIR)/LAPACKE' -j '$(JOBS)' install

    '$(TARGET)-gfortran' \
        -W -Wall -Werror -pedantic \
        '$(PWD)/src/$(PKG)-test.f' -o '$(PREFIX)/$(TARGET)/bin/test-lapack.exe' \
        -llapack

    '$(TARGET)-gcc' \
        -W -Wall -Werror -pedantic \
        '$(PWD)/src/$(PKG)-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-lapacke.exe' \
        -llapacke -llapack -lcblas -lblas -lgfortran -lquadmath
endef
