# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := netcdf
$(PKG)_WEBSITE  := https://www.unidata.ucar.edu/software/netcdf/
$(PKG)_DESCR    := NetCDF
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.6.1
$(PKG)_CHECKSUM := a2fabf27c72a5ee746e3843e1debbaad37cd035767eaede2045371322211eebb
$(PKG)_GH_CONF  := Unidata/netcdf-c/releases,v
$(PKG)_DEPS     := cc curl hdf4 hdf5 jpeg portablexdr zlib

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DENABLE_DOXYGEN=OFF \
        -DENABLE_EXAMPLES=OFF \
        -DENABLE_TESTS=OFF \
        -DBUILD_UTILITIES=OFF \
        -DENABLE_HDF4=ON \
        -DENABLE_HDF4_FILE_TESTS=OFF \
        -DENABLE_NETCDF_4=ON \
        -DENABLE_CDF5=ON \
        -DUSE_HDF5=ON
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # compile test, pkg-config support incomplete
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(SOURCE_DIR)/examples/C/simple.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) libjpeg libcurl --cflags --libs` -lportablexdr
endef
