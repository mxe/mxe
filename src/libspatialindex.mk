# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libspatialindex
$(PKG)_WEBSITE  := https://libspatialindex.github.io/
$(PKG)_DESCR    := libspatialindex
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.5
$(PKG)_CHECKSUM := 31ec0a9305c3bd6b4ad60a5261cba5402366dd7d1969a8846099717778e9a50a
$(PKG)_SUBDIR   := spatialindex-src-$($(PKG)_VERSION)
$(PKG)_FILE     := spatialindex-src-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://download.osgeo.org/libspatialindex/$($(PKG)_FILE)
$(PKG)_DEPS     := cc pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://download.osgeo.org/libspatialindex/' | \
    $(SED) -n 's,.*spatialindex-src-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 '$(INSTALL_STRIP_LIB)'

    # the test program will return 0 on success; -1 on error (with an error message)
    '$(TARGET)-gcc' \
        -W -Wall -ansi -pedantic \
        '$(1)/test/geometry/Intersection.cc' -o '$(PREFIX)/$(TARGET)/bin/test-libspatialindex.exe'\
        `'$(TARGET)-pkg-config' libspatialindex --cflags --libs` \
        -lspatialindex_c -lspatialindex -lstdc++ -pthread
endef
