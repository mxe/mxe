# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := netcdf
$(PKG)_WEBSITE  := https://www.unidata.ucar.edu/software/netcdf/
$(PKG)_DESCR    := NetCDF
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.9.2
$(PKG)_CHECKSUM := bc104d101278c68b303359b3dc4192f81592ae8640f1aee486921138f7f88cb7
$(PKG)_GH_CONF  := Unidata/netcdf-c/releases,v
$(PKG)_DEPS     := cc curl hdf4 hdf5 jpeg libxml2 portablexdr zlib

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DHDF5_USE_STATIC_LIBRARIES=$(CMAKE_STATIC_BOOL) \
        -DENABLE_DOXYGEN=OFF \
        -DENABLE_EXAMPLES=OFF \
        -DENABLE_TESTS=OFF \
        -DBUILD_UTILITIES=OFF \
        -DENABLE_HDF4=ON \
        -DENABLE_HDF4_FILE_TESTS=OFF \
        -DENABLE_NETCDF_4=ON \
        -DUSE_HDF5=ON \
        -DHDF5_VERSION=$(hdf5_VERSION) \
        -DENABLE_LIBXML2=ON \
        $(if $(BUILD_STATIC),-DCMAKE_C_FLAGS=-DLIBXML_STATIC)

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # fix hdf5 libraries
    $(SED) -i -e 's!-lhdf5_hl-\(static\|shared\)!-lhdf5_hl!g' \
        '$(PREFIX)/$(TARGET)/bin/nc-config'
    $(SED) -i -e 's!-lhdf5-\(static\|shared\)!-lhdf5!g' \
        '$(PREFIX)/$(TARGET)/bin/nc-config'

    # compile test, pkg-config support incomplete
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(SOURCE_DIR)/examples/C/simple.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`

endef
