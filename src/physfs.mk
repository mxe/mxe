# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := physfs
$(PKG)_WEBSITE  := https://icculus.org/physfs/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.2
$(PKG)_CHECKSUM := 304df76206d633df5360e738b138c94e82ccf086e50ba84f456d3f8432f9f863
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.bz2
$(PKG)_URL      := https://icculus.org/physfs/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := cc zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://icculus.org/physfs/downloads/?M=D' | \
    $(SED) -n 's,.*<a href="physfs-\([0-9][^"]*\)\.tar.*,\1,pI' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DPHYSFS_BUILD_STATIC=$(CMAKE_STATIC_BOOL) \
        -DPHYSFS_BUILD_SHARED=$(CMAKE_SHARED_BOOL) \
        -DPHYSFS_INTERNAL_ZLIB=FALSE \
        -DPHYSFS_BUILD_TEST=FALSE \
        -DPHYSFS_BUILD_WX_TEST=FALSE
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic -std=c99 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-physfs.exe' \
        -lphysfs -lz
endef
