# This file is part of mingw-cross-env.
# See doc/index.html for further information.


# lapack
PKG             := lapack
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.2
$(PKG)_CHECKSUM := a434c45932f6affb654b3abde21dd669f5751633
$(PKG)_SUBDIR   := lapack-$($(PKG)_VERSION)
$(PKG)_FILE     := lapack-$($(PKG)_VERSION).tgz
$(PKG)_WEBSITE  := http://www.netlib.org/lapack
$(PKG)_URL      := http://www.netlib.org/lapack/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.netlib.org/lapack/' | \
    $(SED) -n 's_for  LAPACK, version \([0-9]\.[0-9]\.[0-9]\)_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD
    cp $(1)/make.inc.example  $(1)/make.inc	
    $(SED) -i 's,PLAT = _LINUX,PLAT = _MINGW32,g'   '$(1)/make.inc'
    $(SED) -i 's,gfortran,$(TARGET)-gfortran,g'   '$(1)/make.inc'
    $(SED) -i 's, ar, $(TARGET)-ar,g'   '$(1)/make.inc'
    $(SED) -i 's, ranlib, $(TARGET)-ranlib,g'   '$(1)/make.inc'

    ## build Blas and Lapack 	
    make -C $(1) lapacklib blaslib
    cp $(1)/lapack_MINGW32.a $(1)/liblapack.a
    cp $(1)/blas_MINGW32.a $(1)/libblas.a
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m664 '$(1)/libblas.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m664 '$(1)/liblapack.a' '$(PREFIX)/$(TARGET)/lib/'
endef


