# This file is part of MXE.
# See index.html for further information.

PKG             := eigen
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.2
$(PKG)_CHECKSUM := 1e1a85681777314805003db5469d1a00785c58df
$(PKG)_SUBDIR   := $(PKG)-$(PKG)-1306d75b4a21
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://bitbucket.org/$(PKG)/$(PKG)/get/$($(PKG)_VERSION).tar.bz2
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

    '$(TARGET)-g++' -W -Wall '$(2).cpp' -o \
        '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' --cflags --libs eigen3`
endef

