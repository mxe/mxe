# This file is part of MXE.
# See index.html for further information.

PKG             := arpack-ng
$(PKG)_VERSION  := 3.1.4
$(PKG)_CHECKSUM := 1fb817346619b04d8fcdc958060cc0eab2c73c6f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)_$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://forge.scilab.org/index.php/p/$(PKG)/downloads/get/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc lapack

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://forge.scilab.org/index.php/p/arpack-ng/downloads/label/5250/' | \
    $(SED) -n 's,.*>arpack-ng\([-_]\)\([0-9.]*\)\.tar\.gz</a></td><td>arpack-ng.*,\2,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-blas='$(PREFIX)/$(TARGET)' \
        --with-lapack='$(PREFIX)/$(TARGET)' \
        LIBS="-llapacke -llapack -lcblas -lblas -lgfortran"
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
