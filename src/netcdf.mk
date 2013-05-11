# This file is part of MXE.
# See index.html for further information.

PKG             := netcdf
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 31b4b3b17146cc8c14a8c7be3fe5f28e5a8a5deb
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.unidata.ucar.edu/downloads/netcdf/ftp/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc curl zlib hdf4 hdf5

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.unidata.ucar.edu/downloads/netcdf/index.jsp' | \
    grep netcdf | \
    $(SED) -n 's,.*href="netcdf-\([0-9_]*\)">.*,\1,p' | \
    head -1 | \
    tr '_' '.'
endef

# NetCDF uses '#ifdef IGNORE' as a synonym to '#if 0' in several places.
# IGNORE is assumed to never be defined, but winbase.h defines it...
# We just replace '#ifdef IGNORE' with '#if 0' to work around this.

define $(PKG)_BUILD
    cd '$(1)' && \
        $(SED) -i -e 's/#ifdef IGNORE/#if 0/' libsrc4/nc4hdf.c libsrc4/ncfunc.c libsrc/attr.c ncgen/cvt.c && \
        ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --enable-netcdf-4 \
        --enable-hdf4 \
        --prefix='$(PREFIX)/$(TARGET)' \
        CPPFLAGS="-D_DLGS_H" \
        LIBS="-lmfhdf -ldf -lportablexdr -lws2_32"
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
