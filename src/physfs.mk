# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# physfs
PKG             := physfs
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.2
$(PKG)_CHECKSUM := 2d3d3cc819ad26542d34451f44050b85635344d0
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_WEBSITE  := http://icculus.org/physfs/
$(PKG)_URL      := http://icculus.org/physfs/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://icculus.org/physfs/downloads/?M=D' | \
    $(SED) -n 's,.*<a href="physfs-\([0-9][^"]*\)\.tar.*,\1,pI' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake .                                   \
        -DCMAKE_SYSTEM_NAME=Windows                        \
        -DCMAKE_FIND_ROOT_PATH='$(PREFIX)/$(TARGET)'       \
        -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER          \
        -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY           \
        -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY           \
        -DCMAKE_C_COMPILER='$(PREFIX)/bin/$(TARGET)-gcc'   \
        -DCMAKE_CXX_COMPILER='$(PREFIX)/bin/$(TARGET)-g++' \
        -DCMAKE_CXX_FLAGS=-D__STDC_CONSTANT_MACROS         \
        -DCMAKE_INCLUDE_PATH='$(PREFIX)/$(TARGET)/include' \
        -DCMAKE_LIB_PATH='$(PREFIX)/$(TARGET)/lib'         \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)'       \
        -DCMAKE_BUILD_TYPE=Release                         \
        -DPHYSFS_BUILD_SHARED=FALSE                        \
        -DPHYSFS_INTERNAL_ZLIB=FALSE                       \
        -DPHYSFS_BUILD_TEST=FALSE                          \
        -DPHYSFS_BUILD_WX_TEST=FALSE
        $(MAKE) -C '$(1)' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic -std=c99\
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-physfs.exe' \
        -lphysfs -lz
endef
