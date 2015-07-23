# This file is part of MXE.
# See index.html for further information.

PKG             := gdal
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.11.2
$(PKG)_CHECKSUM := 6f3ccbe5643805784812072a33c25be0bbff00db
$(PKG)_SUBDIR   := gdal-$($(PKG)_VERSION)
$(PKG)_FILE     := gdal-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.osgeo.org/gdal/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.remotesensing.org/gdal/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc proj zlib libpng libxml2 tiff libgeotiff jpeg openjpeg \
                   giflib expat sqlite curl geos postgresql gta hdf4 hdf5 \
                   json-c netcdf armadillo

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://trac.osgeo.org/gdal/wiki/DownloadSource' | \
    $(SED) -n 's,.*gdal-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_CONFIGURE
    cd '$(1)' && autoreconf -fi
    # The option '--without-threads' means native win32 threading without pthread.
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-bsb \
        --with-grib \
        --with-ogr \
        --with-pam \
        --without-threads \
        --with-armadillo='$(PREFIX)/$(TARGET)' \
        --with-libz='$(PREFIX)/$(TARGET)' \
        --with-png='$(PREFIX)/$(TARGET)' \
        --with-libtiff='$(PREFIX)/$(TARGET)' \
        --with-geotiff='$(PREFIX)/$(TARGET)' \
        --with-jpeg='$(PREFIX)/$(TARGET)' \
        --with-openjpeg='$(PREFIX)/$(TARGET)' \
        --with-gif='$(PREFIX)/$(TARGET)' \
        --with-expat='$(PREFIX)/$(TARGET)' \
        --with-sqlite3='$(PREFIX)/$(TARGET)' \
        --with-gta='$(PREFIX)/$(TARGET)' \
        --with-hdf4='$(PREFIX)/$(TARGET)' \
        --with-hdf5='$(PREFIX)/$(TARGET)' \
        --with-libjson-c='$(PREFIX)/$(TARGET)' \
        --with-netcdf='$(PREFIX)/$(TARGET)' \
        --with-geos='$(PREFIX)/$(TARGET)/bin/geos-config' \
        --with-xml2='$(PREFIX)/$(TARGET)/bin/xml2-config' \
        --without-jasper \
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
    $(MAKE) -C '$(1)/apps'  -j '$(JOBS)' install
    ln -sf '$(PREFIX)/$(TARGET)/bin/gdal-config' '$(PREFIX)/bin/$(TARGET)-gdal-config'
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
