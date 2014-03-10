# This file is part of MXE.
# See index.html for further information.

PKG             := lapack
$(PKG)_VERSION  := 3.5.0
$(PKG)_CHECKSUM := 5870081889bf5d15fd977993daab29cf3c5ea970
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://www.netlib.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.eq.uc.pt/pub/software/math/netlib/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc cblas

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.netlib.org/lapack/' | \
    $(SED) -n 's_.*>LAPACK, version \([0-9]\.[0-9]\.[0-9]\).*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_AR='$(PREFIX)/bin/$(TARGET)-ar' \
        -DCMAKE_RANLIB='$(PREFIX)/bin/$(TARGET)-ranlib' \
        -DLAPACKE=ON \
        -DCMAKE_Fortran_FLAGS=$(if $(findstring x86_64,$(TARGET)),-fdefault-integer-8) \
        .
    cp '$(1)/lapacke/include/lapacke_mangling_with_flags.h' '$(1)/lapacke/include/lapacke_mangling.h'
    $(MAKE) -C '$(1)/SRC'     -j '$(JOBS)' install
    $(MAKE) -C '$(1)/lapacke' -j '$(JOBS)' install

    '$(TARGET)-gfortran' \
        -W -Wall -Werror -pedantic \
        '$(2).f' -o '$(PREFIX)/$(TARGET)/bin/test-lapack.exe' \
        -llapack

    '$(TARGET)-gcc' \
        -W -Wall -Werror -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-lapacke.exe' \
        -llapacke -llapack -lcblas -lblas -lgfortran
endef
