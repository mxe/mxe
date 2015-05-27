# This file is part of MXE.
# See index.html for further information.

PKG             := netcdf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.3.0
$(PKG)_CHECKSUM := 246e4963e66e1c175563cc9a714e9da0a19b8b07
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.unidata.ucar.edu/downloads/netcdf/ftp/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc curl hdf4 hdf5 portablexdr zlib

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
	$(MXE_CONFIGURE_OPTS) \
        --enable-netcdf-4 \
        --enable-hdf4 \
 	--disable-testsets \
 	--disable-examples \
        CPPFLAGS="-D_DLGS_H -DWIN32_LEAN_AND_MEAN" \
        LIBS="-lmfhdf -ldf -lportablexdr -lws2_32"

    $(MAKE) -C '$(1)' -j '$(JOBS)' \
    LDFLAGS=-no-undefined

    $(MAKE) -C '$(1)' -j 1 install
endef
