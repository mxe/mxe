# This file is part of MXE.
# See index.html for further information.

PKG             := hdf4
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 9d4ab457ccb8e582c265ca3f5f2ec90614d89da4
$(PKG)_SUBDIR   := hdf-$($(PKG)_VERSION)
$(PKG)_FILE     := hdf-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.hdfgroup.org/ftp/HDF/HDF_Current/src/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib jpeg portablexdr

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.hdfgroup.org/ftp/HDF/HDF_Current/src/' | \
    grep '<a href.*hdf.*bz2' | \
    $(SED) -n 's,.*hdf-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && $(LIBTOOLIZE) --force
    cd '$(1)' && autoreconf && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --disable-fortran \
        --disable-netcdf \
        --prefix='$(PREFIX)/$(TARGET)' \
        CPPFLAGS="-DH4_F77_FUNC\(name,NAME\)=NAME"
    $(MAKE) -C '$(1)'/hdf/src -j '$(JOBS)'
    $(MAKE) -C '$(1)'/hdf/src -j 1 install
    $(MAKE) -C '$(1)'/mfhdf/libsrc -j '$(JOBS)'
    $(MAKE) -C '$(1)'/mfhdf/libsrc -j 1 install
endef
