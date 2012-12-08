# This file is part of MXE.
# See index.html for further information.

PKG             := eigen
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := b788877a4d4b1685ee2a5d738a65b04b6a21ff3d
$(PKG)_SUBDIR   := $(PKG)-$(PKG)-5097c01bcdc4
$(PKG)_FILE     := $($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://bitbucket.org/$(PKG)/$(PKG)/get/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://eigen.tuxfamily.org/index.php?title=Main_Page#Download' | \
    grep 'eigen/get/' | \
    $(SED) -n 's,.*eigen/get/\(3[^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && mkdir build && cd build && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_BUILD_TYPE=Release \
        -DEIGEN_BUILD_PKGCONFIG=ON \
        -Drun_res=1 -Drun_res__TRYRUN_OUTPUT=""
    $(MAKE) -C '$(1)'/build -j '$(JOBS)' install VERBOSE=1
endef
