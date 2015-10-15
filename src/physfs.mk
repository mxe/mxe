# This file is part of MXE.
# See index.html for further information.

PKG             := physfs
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.3
$(PKG)_CHECKSUM := ca862097c0fb451f2cacd286194d071289342c107b6fe69079c079883ff66b69
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.bz2
$(PKG)_URL      := http://icculus.org/physfs/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://icculus.org/physfs/downloads/?M=D' | \
    $(SED) -n 's,.*<a href="physfs-\([0-9][^"]*\)\.tar.*,\1,pI' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        $(if $(BUILD_SHARED), \
            -DPHYSFS_BUILD_SHARED=TRUE \
            -DPHYSFS_BUILD_STATIC=FALSE, \
            -DPHYSFS_BUILD_SHARED=FALSE) \
        -DPHYSFS_INTERNAL_ZLIB=FALSE \
        -DPHYSFS_BUILD_TEST=FALSE \
        -DPHYSFS_BUILD_WX_TEST=FALSE
        $(MAKE) -C '$(1)' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic -std=c99 \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-physfs.exe' \
        -lphysfs -lz
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =
