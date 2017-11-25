# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gdal
$(PKG)_WEBSITE  := http://www.gdal.org/
$(PKG)_DESCR    := GDAL
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.3
$(PKG)_CHECKSUM := 52f01bda8968643633016769607e6082a8ba1c746fadc2c1abe12cf7dc8f61dd
$(PKG)_SUBDIR   := gdal-$($(PKG)_VERSION)
$(PKG)_FILE     := gdal-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.osgeo.org/gdal/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.remotesensing.org/gdal/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc armadillo curl expat geos giflib gta hdf4 hdf5 \
                   jpeg json-c libgeotiff libmysqlclient libpng libxml2 \
                   netcdf openjpeg postgresql proj spatialite sqlite tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://trac.osgeo.org/gdal/wiki/DownloadSource' | \
    $(SED) -n 's,.*gdal-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi -I ./m4
    # The option '--with-threads=no' means native win32 threading without pthread.
    # mysql uses threading from Vista onwards - '-D_WIN32_WINNT=0x0600'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-armadillo='$(PREFIX)/$(TARGET)' \
        --with-bsb \
        --with-cfitsio=no \
        --with-dods-root=no \
        --with-dwgdirect=no \
        --with-ecw=no \
        --with-epsilon=no \
        --with-expat='$(PREFIX)/$(TARGET)' \
        --with-fme=no \
        --with-geos='$(PREFIX)/$(TARGET)/bin/geos-config' \
        --with-geotiff='$(PREFIX)/$(TARGET)' \
        --with-gif='$(PREFIX)/$(TARGET)' \
        --with-grass=no \
        --with-grib \
        --with-gta='$(PREFIX)/$(TARGET)' \
        --with-hdf4='$(PREFIX)/$(TARGET)' \
        --with-hdf5='$(PREFIX)/$(TARGET)' \
        --with-idb=no \
        --with-ingres=no \
        --with-jasper=no \
        --with-jp2mrsid=no \
        --with-jpeg='$(PREFIX)/$(TARGET)' \
        --with-kakadu=no \
        --with-libgrass=no \
        --with-libjson-c='$(PREFIX)/$(TARGET)' \
        --with-libtiff='$(PREFIX)/$(TARGET)' \
        --with-libz='$(PREFIX)/$(TARGET)' \
        --with-mrsid=no \
        --with-msg=no \
        --with-mysql='$(PREFIX)/$(TARGET)/bin/mysql_config' \
        --with-netcdf='$(PREFIX)/$(TARGET)' \
        --with-oci=no \
        --with-odbc=no \
        --with-ogdi=no \
        --with-openjpeg='$(PREFIX)/$(TARGET)' \
        --with-pam \
        --with-pcidsk=no \
        --with-pcraster=no \
        --with-perl=no \
        --with-php=no \
        --with-png='$(PREFIX)/$(TARGET)' \
        --with-python=no \
        --with-sde=no \
        --with-spatialite=yes \
        --with-sqlite3='$(PREFIX)/$(TARGET)' \
        --with-threads=no \
        --with-xerces=no \
        --with-xml2='$(PREFIX)/$(TARGET)/bin/xml2-config' \
        --with-pg='$(PREFIX)/$(TARGET)/bin/pg_config' \
        CXXFLAGS='-D_WIN32_WINNT=0x0600' \
        LIBS="-ljpeg -lsecur32 -lportablexdr `'$(TARGET)-pkg-config' --libs openssl libtiff-4 spatialite freexl armadillo`"

    $(MAKE) -C '$(1)'       -j '$(JOBS)' lib-target
    # gdal doesn't have an install-strip target
    # --strip-debug doesn't reduce size by much, --strip-all breaks libs
    $(if $(STRIP_LIB),-'$(TARGET)-strip' --strip-debug '$(1)/.libs'/*)
    $(MAKE) -C '$(1)'       -j '$(JOBS)' gdal.pc
    $(MAKE) -C '$(1)'       -j '$(JOBS)' install-actions
    $(MAKE) -C '$(1)/port'  -j '$(JOBS)' install
    $(MAKE) -C '$(1)/gcore' -j '$(JOBS)' install
    $(MAKE) -C '$(1)/frmts' -j '$(JOBS)' install
    $(MAKE) -C '$(1)/alg'   -j '$(JOBS)' install
    $(MAKE) -C '$(1)/ogr'   -j '$(JOBS)' install OGR_ENABLED=
    $(MAKE) -C '$(1)/apps'  -j '$(JOBS)' all
    $(if $(STRIP_EXE),-'$(TARGET)-strip' '$(1)/apps'/*.exe)
    $(MAKE) -C '$(1)/apps'  -j '$(JOBS)' install
    ln -sf '$(PREFIX)/$(TARGET)/bin/gdal-config' '$(PREFIX)/bin/$(TARGET)-gdal-config'
endef
