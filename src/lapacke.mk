# This file is part of MXE.
# See index.html for further information.

PKG             := lapacke
PKG_N           := lapack
$(PKG)_VERSION  := 3.4.2
$(PKG)_CHECKSUM := 93a6e4e6639aaf00571d53a580ddc415416e868b
$(PKG)_SUBDIR   := $(PKG_N)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG_N)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://www.netlib.org/$(PKG_N)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.eq.uc.pt/pub/software/math/netlib/$(PKG_N)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc lapack

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.netlib.org/lapack/' | \
    $(SED) -n 's_.*>LAPACKE, version \([0-9]\.[0-9]\.[0-9]\).*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_AR='$(PREFIX)/bin/$(TARGET)-ar' \
        -DCMAKE_RANLIB='$(PREFIX)/bin/$(TARGET)-ranlib' \
        -DLAPACKE=ON \
        .
    $(MAKE) -C '$(1)/lapacke' -j '$(JOBS)' install

endef
