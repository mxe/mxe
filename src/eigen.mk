# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := eigen
$(PKG)_WEBSITE  := https://eigen.tuxfamily.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.5
$(PKG)_CHECKSUM := 5f6e6cb88188e34185f43cb819d7dab9b48ef493774ff834e568f4805d3dc2f9
$(PKG)_SUBDIR   := $(PKG)-$(PKG)-bdd17ee3b1b3
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://bitbucket.org/$(PKG)/$(PKG)/get/$($(PKG)_VERSION).tar.bz2
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://eigen.tuxfamily.org/index.php?title=Main_Page#Download' | \
    grep 'eigen/get/' | \
    $(SED) -n 's,.*eigen/get/\(3[^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && mkdir build && cd build && '$(TARGET)-cmake' .. \
        -DEIGEN_BUILD_PKGCONFIG=ON \
        -Drun_res=1 -Drun_res__TRYRUN_OUTPUT=""
    $(MAKE) -C '$(1)'/build -j '$(JOBS)' install VERBOSE=1

    '$(TARGET)-g++' -W -Wall '$(TEST_FILE)' -o \
        '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' --cflags --libs eigen3`
endef

