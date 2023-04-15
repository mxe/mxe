# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gdal
$(PKG)_WEBSITE  := https://www.gdal.org/
$(PKG)_DESCR    := GDAL
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.6.2
$(PKG)_CHECKSUM := 35f40d2e08061b342513cdcddc2b997b3814ef8254514f0ef1e8bc7aa56cf681
$(PKG)_SUBDIR   := gdal-$($(PKG)_VERSION)
$(PKG)_FILE     := gdal-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.osgeo.org/gdal/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc armadillo curl expat geos giflib gta hdf4 hdf5 \
                   jpeg json-c libgeotiff libmysqlclient libpng libxml2 \
                   netcdf openjpeg postgresql proj spatialite sqlite tiff zlib \
                   poppler freetype

define $(PKG)_UPDATE
        $(WGET) -q -O- 'https://download.osgeo.org/gdal/CURRENT' | \
        $(SED) -n 's,.*title="gdal-\([0-9.]*\)\.tar\.gz\.md5".*,\1,p'| \
        tail -1
endef

define $(PKG)_BUILD
    # Explicitly enable packages known to work to avoid CMake auto-detection
    # enabling a package that might not work
    cd '$(BUILD_DIR)' && $(TARGET)-cmake --trace-expand '$(SOURCE_DIR)' \
        -DCMAKE_CXX_FLAGS='-Wno-deprecated-copy -Wno-class-memaccess $(if $(BUILD_STATIC),-DOPJ_STATIC -DCURL_STATICLIB,)' \
        -DCMAKE_C_FLAGS='-Wno-format' \
        -DGDAL_USE_EXTERNAL_LIBS:BOOL=OFF\
        -DGDAL_USE_ARMADILLO:BOOL=ON \
        -DGDAL_USE_BISON:BOOL=ON \
        -DGDAL_USE_CURL:BOOL=ON \
        -DGDAL_USE_EXPAT:BOOL=ON \
        -DGDAL_USE_FREEXL:BOOL=ON \
        -DGDAL_USE_GEOS:BOOL=ON \
        -DGDAL_USE_GIF:BOOL=ON \
        -DGDAL_USE_GTA:BOOL=ON \
        -DGDAL_USE_GEOTIFF:BOOL=ON \
        -DGDAL_USE_HDF4:BOOL=ON \
        -DGDAL_USE_HDF5:BOOL=ON \
        -DGDAL_USE_ICONV:BOOL=ON \
        -DGDAL_USE_JPEG:BOOL=ON \
        -DGDAL_USE_JSONC:BOOL=ON \
        -DGDAL_USE_JAVA:BOOL=ON \
        -DGDAL_USE_LIBLZMA:BOOL=ON \
        -DGDAL_USE_LIBXML2:BOOL=ON \
        -DGDAL_USE_MYSQL:BOOL=ON \
        -DGDAL_USE_NETCDF:BOOL=ON \
        -DGDAL_USE_ODBC:BOOL=ON \
        -DGDAL_USE_OPENJPEG:BOOL=ON \
        -DGDAL_USE_OPENSSL:BOOL=ON \
        -DGDAL_USE_PCRE2:BOOL=ON \
        -DGDAL_USE_PNG:BOOL=ON \
        -DGDAL_USE_PROJ:BOOL=ON \
        -DGDAL_USE_PERL:BOOL=ON \
        -DGDAL_USE_POPPLER:BOOL=ON \
        -DGDAL_USE_POSTGRESQL:BOOL=ON \
        -DGDAL_USE_SPATIALITE:BOOL=ON \
        -DGDAL_USE_SQLITE3:BOOL=ON \
        -DGDAL_USE_TIFF:BOOL=ON \
        -DGDAL_USE_WEBP:BOOL=ON \
        -DGDAL_USE_ZLIB:BOOL=ON \
        -DGDAL_USE_ZSTD:BOOL=ON \
        -DBUILD_SHARED_LIBS:BOOL=$(if $(BUILD_SHARED),ON,OFF) \
        -DHDF5_USE_STATIC_LIBRARIES:BOOL=$(if $(BUILD_SHARED),OFF,ON) \
        -DBLA_STATIC=$(if $(BUILD_SHARED),OFF,ON) \
        -DBLA_VENDOR="OpenBLAS" \
        -DLAPACK_LIBRARIES="`'$(TARGET)-pkg-config' lapack --cflags --libs` -lgfortran -lquadmath"

    # Known not to work or disabled in previous versions
    # -DGDAL_USE_THREADS:BOOL=ON \
    # -DGDAL_USE_OPENEXR:BOOL=ON \

    $(MAKE) VERBOSE=1 -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) VERBOSE=1 -C '$(BUILD_DIR)' -j '$(JOBS)' install/strip

    ln -sf '$(PREFIX)/$(TARGET)/bin/gdal-config' '$(PREFIX)/bin/$(TARGET)-gdal-config'
endef
