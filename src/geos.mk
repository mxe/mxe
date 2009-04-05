# GEOS

PKG             := geos
$(PKG)_VERSION  := 3.1.0
$(PKG)_CHECKSUM := a36b462e4afac91d7aacef9944bff0706ea64168
$(PKG)_SUBDIR   := geos-$($(PKG)_VERSION)
$(PKG)_FILE     := geos-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://trac.osgeo.org/geos/
$(PKG)_URL      := http://download.osgeo.org/geos/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://geos.refractions.net/' | \
    $(SED) -n 's,.*geos-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,-lgeos,-lgeos -lstdc++,' -i '$(1)/tools/geos-config.in'
    $(SED) 's,-L\$${libdir}$$,-L$${libdir} -lgeos -lstdc++,' -i '$(1)/tools/geos-config.in'
    $(SED) 's,\$$WARNFLAGS -ansi,\$$WARNFLAGS,' -i '$(1)/configure.in'
    touch '$(1)/aclocal.m4'
    $(SED) 's,\$$WARNFLAGS -ansi,\$$WARNFLAGS,' -i '$(1)/configure'
    touch '$(1)/Makefile.in'
    touch '$(1)/source/headers/config.h.in'
    touch '$(1)/source/headers/geos/platform.h.in'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-swig
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
