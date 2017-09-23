# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := blas
$(PKG)_WEBSITE  := http://www.netlib.org/blas/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.7.1
$(PKG)_CHECKSUM := c5a654351f0b046a502bf04b16740b9ab49c7d8512d6d57ad3a64184c8e575c3
$(PKG)_SUBDIR   := BLAS-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://www.netlib.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.netlib.org/blas/' | \
    $(SED) -n 's,.*>REFERENCE BLAS Version \([0-9.]*\)<.*,\1,p'
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' \
        FORTRAN='$(TARGET)-gfortran' \
        RANLIB='$(TARGET)-ranlib' \
        ARCH='$(TARGET)-ar' \
        BLASLIB='libblas.a'

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(if $(BUILD_STATIC), \
        $(INSTALL) -m644 '$(1)/libblas.a' '$(PREFIX)/$(TARGET)/lib/', \
        $(MAKE_SHARED_FROM_STATIC) '$(1)/libblas.a' --ld '$(TARGET)-gfortran' \
    )
endef
