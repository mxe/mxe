# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := spatialite
$(PKG)_WEBSITE  := https://www.gaia-gis.it/fossil/libspatialite/index
$(PKG)_DESCR    := SpatiaLite
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.4.0-RC1
$(PKG)_CHECKSUM := 80f7fff0a147044c5eb197e565f598ac1f137d86d0a548cbc8f52fb7ff7cac68
$(PKG)_SUBDIR   := libspatialite-$($(PKG)_VERSION)
$(PKG)_FILE     := libspatialite-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.gaia-gis.it/gaia-sins/libspatialite-sources/$($(PKG)_FILE)
$(PKG)_DEPS     := cc dlfcn-win32 freexl geos libiconv libxml2 proj sqlite zlib

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
        --enable-freexl=yes \
        --with-geosconfig='$(PREFIX)/$(TARGET)/bin/geos-config'
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
