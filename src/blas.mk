# This file is part of MXE.
# See index.html for further information.

PKG             := blas
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1
$(PKG)_CHECKSUM := 6d130c550b17a0bc51c8dbfcd662fb15520b23b5
$(PKG)_SUBDIR   := BLAS
$(PKG)_FILE     := $(PKG).tgz
$(PKG)_URL      := http://www.netlib.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.eq.uc.pt/pub/software/math/netlib/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 1
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' \
        FORTRAN='$(TARGET)-gfortran' \
        RANLIB='$(TARGET)-ranlib' \
        ARCH='$(TARGET)-ar' \
        BLASLIB='libblas.a' \
        OPTS=$(if $(findstring x86_64,$(TARGET)),-fdefault-integer-8)

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(if $(BUILD_STATIC), \
        $(INSTALL) -m644 '$(1)/libblas.a' '$(PREFIX)/$(TARGET)/lib/', \
        $(MAKE_SHARED_FROM_STATIC) '$(1)/libblas.a' --ld '$(TARGET)-gfortran' \
    )
endef
