# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := armadillo
$(PKG)_WEBSITE  := http://arma.sourceforge.net/
$(PKG)_DESCR    := Armadillo C++ linear algebra library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.400.3
$(PKG)_CHECKSUM := 019ce442a1bcad4c5da0bc01ee35333c9a0783ec6a58237ae1e774da68cd4f2f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/arma/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc blas lapack

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/arma/files/' | \
    $(SED) -n 's,.*/armadillo-\([0-9.]*\)[.]tar.*".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && '$(TARGET)-cmake' .. \
        -DARMA_USE_WRAPPER=false
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install VERBOSE=1

    '$(TARGET)-g++' \
        -W -Wall -Werror \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-armadillo.exe' \
        -larmadillo -llapack -lblas -lgfortran -lquadmath
endef
