# This file is part of MXE.
# See index.html for further information.

PKG             := gdal
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := e522b95056905e4c41047fdb42c0ca172ef3ad25
$(PKG)_SUBDIR   := gdal-$($(PKG)_VERSION)
$(PKG)_FILE     := gdal-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.osgeo.org/gdal/CURRENT/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.remotesensing.org/gdal/CURRENT/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib libpng tiff libgeotiff jpeg jasper giflib expat sqlite curl geos postgresql gta hdf4 hdf5 netcdf

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://trac.osgeo.org/gdal/wiki/DownloadSource' | \
    $(SED) -n 's,.*gdal-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # The option '--without-threads' means native win32 threading without pthread.
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-bsb \
        --with-grib \
        --with-ogr \
        --with-vfk \
        --with-pam \
        --without-threads \
        --with-libz='$(PREFIX)/$(TARGET)' \
        --with-png='$(PREFIX)/$(TARGET)' \
        --with-libtiff='$(PREFIX)/$(TARGET)' \
        --with-geotiff='$(PREFIX)/$(TARGET)' \
        --with-jpeg='$(PREFIX)/$(TARGET)' \
        --with-jasper='$(PREFIX)/$(TARGET)' \
        --with-gif='$(PREFIX)/$(TARGET)' \
        --with-expat='$(PREFIX)/$(TARGET)' \
        --with-sqlite3='$(PREFIX)/$(TARGET)' \
        --with-curl='$(PREFIX)/$(TARGET)/bin/curl-config' \
        --with-geos='$(PREFIX)/$(TARGET)/bin/geos-config' \
        --with-pg='$(PREFIX)/bin/$(TARGET)-pg_config' \
        --with-gta='$(PREFIX)/$(TARGET)' \
        --with-hdf4='$(PREFIX)/$(TARGET)' \
        --with-hdf5='$(PREFIX)/$(TARGET)' \
        --with-netcdf='$(PREFIX)/$(TARGET)' \
        --without-odbc \
        --without-static-proj4 \
        --without-xerces \
        --without-grass \
        --without-libgrass \
        --without-spatialite \
        --without-cfitsio \
        --without-pcraster \
        --without-pcidsk \
        --without-ogdi \
        --without-fme \
        --without-ecw \
        --without-kakadu \
        --without-mrsid \
        --without-jp2mrsid \
        --without-msg \
        --without-oci \
        --without-mysql \
        --without-ingres \
        --without-dods-root \
        --without-dwgdirect \
        --without-idb \
        --without-sde \
        --without-epsilon \
        --without-perl \
        --without-php \
        --without-ruby \
        --without-python \
        LIBS="-ljpeg -lsecur32 -lportablexdr `'$(TARGET)-pkg-config' --libs openssl libtiff-4`"
    $(MAKE) -C '$(1)'       -j 1 lib-target
    $(MAKE) -C '$(1)'       -j 1 install-lib
    $(MAKE) -C '$(1)/port'  -j 1 install
    $(MAKE) -C '$(1)/gcore' -j 1 install
    $(MAKE) -C '$(1)/frmts' -j 1 install
    $(MAKE) -C '$(1)/alg'   -j 1 install
    $(MAKE) -C '$(1)/ogr'   -j 1 install OGR_ENABLED=
    $(MAKE) -C '$(1)/apps'  -j 1 install BIN_LIST=
    ln -sf '$(PREFIX)/$(TARGET)/bin/gdal-config' '$(PREFIX)/bin/$(TARGET)-gdal-config'
endef
