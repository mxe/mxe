# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := bullet
$(PKG)_WEBSITE  := http://bulletphysics.org/
$(PKG)_DESCR    := Bullet physics, version 2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.82-r2704
$(PKG)_CHECKSUM := 67e4c9eb76f7adf99501d726d8ad5e9b525dfd0843fbce9ca73aaca4ba9eced2
$(PKG)_SUBDIR   := bullet-$($(PKG)_VERSION)
$(PKG)_FILE     := bullet-$($(PKG)_VERSION).tgz
$(PKG)_URL      := https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/bullet/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://code.google.com/p/bullet/downloads/list?sort=-uploaded' | \
    $(SED) -n 's,.*bullet-\([0-9][^<]*\)\.tgz.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(TARGET)-cmake' . \
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
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
