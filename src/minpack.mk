# This file is part of MXE.
# See index.html for further information.

PKG             := minpack
$(PKG)_IGNORE   :=
$(PKG)_SUBDIR   :=
$(PKG)_FILE     := minpack.f90
$(PKG)_URL      := http://people.sc.fsu.edu/~jburkardt/f_src/minpack/$($(PKG)_FILE)
$(PKG)_DEPS     := gfortran

define $(PKG)_UPDATE
    echo 1
endef

define $(PKG)_BUILD
    gfortran -c -g minpack.f90 

    $(INSTALL) -d                           '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/minpack.o'      '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d                           '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 'minpack.hpp'         '$(PREFIX)/$(TARGET)/include/'
endef

