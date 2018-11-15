# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := netcdf-cxx4
$(PKG)_WEBSITE  := https://www.unidata.ucar.edu/software/netcdf/
$(PKG)_DESCR    := NetCDF-CXX4
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.3.0
$(PKG)_CHECKSUM := 25da1c97d7a01bc4cee34121c32909872edd38404589c0427fefa1301743f18f
$(PKG)_GH_CONF  := Unidata/netcdf-cxx4/releases,v
$(PKG)_DEPS     := cc netcdf

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DENABLE_DOXYGEN=OFF \
        -DNCXX_ENABLE_TESTS=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # compile test, pkg-config support incomplete
    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(SOURCE_DIR)/examples/simple_xy_rd.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        -l$(PKG) `'$(TARGET)-pkg-config' netcdf libjpeg libcurl --cflags --libs` -lportablexdr
endef
