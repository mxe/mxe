# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := hdf4
$(PKG)_WEBSITE  := https://www.hdfgroup.org/hdf4/
$(PKG)_DESCR    := HDF4
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2.10
$(PKG)_CHECKSUM := 44e9c7f5bdd463c4a01738f44ad4f0ee9c68e3f0cb9872eca160e3fddc8b994c
$(PKG)_SUBDIR   := hdf-$($(PKG)_VERSION)
$(PKG)_FILE     := hdf-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://support.hdfgroup.org/ftp/HDF/releases/HDF$($(PKG)_VERSION)/src/$($(PKG)_FILE)
$(PKG)_DEPS     := cc jpeg portablexdr zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.hdfgroup.org/ftp/HDF/HDF_Current/src/' | \
    grep '<a href.*hdf.*bz2' | \
    $(SED) -n 's,.*hdf-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && $(LIBTOOLIZE) --force
    cd '$(1)' && autoreconf --install
    cd '$(1)' && ./configure \
    $(MXE_CONFIGURE_OPTS) \
        --disable-fortran \
        --disable-netcdf \
        AR='$(TARGET)-ar' \
        LIBS="-lportablexdr -lws2_32" \
        $(if $(BUILD_SHARED), \
            CPPFLAGS="-DH4_F77_FUNC\(name,NAME\)=NAME -DH4_BUILT_AS_DYNAMIC_LIB=1 -DBIG_LONGS", \
            CPPFLAGS="-DH4_F77_FUNC\(name,NAME\)=NAME -DH4_BUILT_AS_STATIC_LIB=1")
    $(MAKE) -C '$(1)'/mfhdf/xdr -j '$(JOBS)' \
        LDFLAGS=-no-undefined

    $(MAKE) -C '$(1)'/hdf/src -j '$(JOBS)' \
        LDFLAGS=-no-undefined
    $(MAKE) -C '$(1)'/hdf/src -j 1 install

    $(MAKE) -C '$(1)'/mfhdf/libsrc -j '$(JOBS)' \
        LDFLAGS="-no-undefined -ldf"
    $(MAKE) -C '$(1)'/mfhdf/libsrc -j 1 install
endef
