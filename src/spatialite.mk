# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := spatialite
$(PKG)_WEBSITE  := https://www.gaia-gis.it/fossil/libspatialite/index
$(PKG)_DESCR    := SpatiaLite
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.1.0
$(PKG)_CHECKSUM := 43be2dd349daffe016dd1400c5d11285828c22fea35ca5109f21f3ed50605080
$(PKG)_SUBDIR   := libspatialite-$($(PKG)_VERSION)
$(PKG)_FILE     := libspatialite-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.gaia-gis.it/gaia-sins/libspatialite-sources/$($(PKG)_FILE)
$(PKG)_DEPS     := cc dlfcn-win32 freexl geos libiconv libxml2 minizip proj sqlite zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.gaia-gis.it/gaia-sins/libspatialite-sources/' | \
    $(SED) -n 's,.*libspatialite-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    # freeXL support is only necessary if you want to be able to parse .xls files.
    # If you disable freexl support, remove freexl from the test program below.
    cd '$(SOURCE_DIR)' && autoreconf -fi -I ./m4
    cd '$(SOURCE_DIR)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        CFLAGS="`'$(TARGET)-pkg-config' --cflags minizip`" \
        LIBS="`'$(TARGET)-pkg-config' --libs freexl proj minizip`" \
        --enable-freexl=yes \
        --disable-rttopo \
        --with-geosconfig='$(PREFIX)/$(TARGET)/bin/geos-config'
    # also compiles demos
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)' $(if $(BUILD_SHARED), LDFLAGS='-no-undefined')
    $(MAKE) -C '$(SOURCE_DIR)' -j 1  $(INSTALL_STRIP_LIB)

    # compile one of the demo programs
    '$(TARGET)-gcc' $(if $(BUILD_SHARED), -Wno-undefined) \
        -W -Wall -ansi -pedantic \
        '$(SOURCE_DIR)/examples/demo4.c' -o '$(PREFIX)/$(TARGET)/bin/test-spatialite.exe' \
        `'$(TARGET)-pkg-config' $(PKG) sqlite3 freexl proj zlib liblzma --cflags --libs`

    # create a batch file to run the test program (as the program requires arguments)
    (printf 'REM run against a database that should not exist, but will be removed afterward to save space.\r\n'; \
     printf 'test-spatialite.exe test-db.sqlite\r\n'; \
     printf 'del test-db.sqlite\r\n';) \
     > '$(PREFIX)/$(TARGET)/bin/test-spatialite.bat'
endef
