# This file is part of MXE.
# See index.html for further information.

PKG             := gdal
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.11.0
$(PKG)_CHECKSUM := 25efd2bffdea2e841377ca8c1fd49d89d02ac87e
$(PKG)_SUBDIR   := gdal-$($(PKG)_VERSION)
$(PKG)_FILE     := gdal-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.osgeo.org/gdal/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.remotesensing.org/gdal/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc proj zlib libpng tiff libgeotiff jpeg jasper giflib expat sqlite curl geos postgresql gta hdf4 hdf5 json-c netcdf

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://trac.osgeo.org/gdal/wiki/DownloadSource' | \
    $(SED) -n 's,.*gdal-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_CONFIGURE
    # The option '--without-threads' means native win32 threading without pthread.
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build='$(BUILD)' \
        --enable-static \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-bsb \
        --with-grib \
        --with-ogr \
        --with-pam \
        --without-threads \
        --with-static-proj4 \
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
        --with-hdf5='$(PREFIX)/$(TARGET)' \
        --with-libjson-c='$(PREFIX)/$(TARGET)' \
        --without-odbc \
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
        --without-python
endef

define $(PKG)_MAKE
    $(MAKE) -C '$(1)'       -j '$(JOBS)' lib-target
    $(MAKE) -C '$(1)'       -j '$(JOBS)' install-lib
    $(MAKE) -C '$(1)/port'  -j '$(JOBS)' install
    $(MAKE) -C '$(1)/gcore' -j '$(JOBS)' install
    $(MAKE) -C '$(1)/frmts' -j '$(JOBS)' install
    $(MAKE) -C '$(1)/alg'   -j '$(JOBS)' install
    $(MAKE) -C '$(1)/ogr'   -j '$(JOBS)' install OGR_ENABLED=
    $(MAKE) -C '$(1)/apps'  -j '$(JOBS)' install BIN_LIST=
    ln -sf '$(PREFIX)/$(TARGET)/bin/gdal-config' '$(PREFIX)/bin/$(TARGET)-gdal-config'
endef

define $(PKG)_BUILD
    $($(PKG)_CONFIGURE)\
        --with-hdf4='$(PREFIX)/$(TARGET)' \
        --with-netcdf='$(PREFIX)/$(TARGET)' \
        LIBS="-ljpeg -lsecur32 -lportablexdr `'$(TARGET)-pkg-config' --libs openssl libtiff-4`"
    $($(PKG)_MAKE)
endef

define $(PKG)_BUILD_x86_64-w64-mingw32
    $($(PKG)_CONFIGURE) \
        LIBS="-ljpeg -lsecur32 `'$(TARGET)-pkg-config' --libs openssl libtiff-4`"
    $($(PKG)_MAKE)
endef

define $(PKG)_BUILD_i686-w64-mingw32
    $($(PKG)_CONFIGURE) \
        --with-netcdf='$(PREFIX)/$(TARGET)' \
        LIBS="-ljpeg -lsecur32 -lportablexdr `'$(TARGET)-pkg-config' --libs openssl libtiff-4`"
    $($(PKG)_MAKE)
endef

$(PKG)_BUILD_i686-pc-mingw32.shared =
$(PKG)_BUILD_i686-w64-mingw32.shared =
$(PKG)_BUILD_x86_64-w64-mingw32.shared =
