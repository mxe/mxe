# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := blas
$(PKG)_WEBSITE  := http://www.netlib.org/blas/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.5.0
$(PKG)_CHECKSUM := ef7d775d380f255d1902bce374ff7c8a594846454fcaeae552292168af1aca24
$(PKG)_SUBDIR   := BLAS-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://www.netlib.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc openblas

$(PKG)_MESSAGE  :=*** blas has been replaced by openblas ***

define $(PKG)_UPDATE
    echo 'Warning: blas has been replaced by openblas' >&2;
    echo $(blas_VERSION)
endef

define $(PKG)_DISABLED_BUILD
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
