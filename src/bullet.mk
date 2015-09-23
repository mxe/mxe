# This file is part of MXE.
# See index.html for further information.

PKG             := bullet
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.82-r2704
$(PKG)_CHECKSUM := 67e4c9eb76f7adf99501d726d8ad5e9b525dfd0843fbce9ca73aaca4ba9eced2
$(PKG)_SUBDIR   := bullet-$($(PKG)_VERSION)
$(PKG)_FILE     := bullet-$($(PKG)_VERSION).tgz
$(PKG)_URL      := https://bullet.googlecode.com/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://code.google.com/p/bullet/downloads/list?sort=-uploaded' | \
    $(SED) -n 's,.*bullet-\([0-9][^<]*\)\.tgz.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DINSTALL_LIBS=ON \
        -DBUILD_CPU_DEMOS=OFF \
        -DBUILD_DEMOS=OFF \
        -DBUILD_EXTRAS=OFF \
        -DBUILD_MULTITHREADING=OFF \
        -DBUILD_UNIT_TESTS=OFF \
        -DUSE_CUSTOM_VECOR_MATH=OFF \
        -DUSE_DOUBLE_PRECISION=OFF \
        -DUSE_GLUT=OFF \
        -DUSE_GRAPHICAL_BENCHMARK=OFF
    $(MAKE) -C '$(1)' -j '$(JOBS)' install VERBOSE=1

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
