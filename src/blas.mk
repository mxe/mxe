# This file is part of mingw-cross-env.
# See doc/index.html for further information.
# 
#

# blas
PKG             := blas
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 
$(PKG)_CHECKSUM := 0aeca4ed45f2e5519977747ed6bcf80d1b0335d2
$(PKG)_SUBDIR   := BLAS
$(PKG)_FILE     := blas.tgz
$(PKG)_WEBSITE  := http://www.netlib.org/
$(PKG)_URL      := http://www.netlib.org/blas/blas.tgz
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
endef

define $(PKG)_BUILD
    
    $(SED) -i 's,$$(FORTRAN),$(TARGET)-gfortran,g'   '$(1)/Makefile'
    make -C $(1) 
    cd $(1) && $(TARGET)-ar cr libblas.a *.o 

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m664 '$(1)/libblas.a' '$(PREFIX)/$(TARGET)/lib/'

endef


