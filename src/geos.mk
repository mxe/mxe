# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GEOS
PKG             := geos
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.2
$(PKG)_CHECKSUM := 6917d6d1d4e79f58d9f931bf351024709fabbc5a
$(PKG)_SUBDIR   := geos-$($(PKG)_VERSION)
$(PKG)_FILE     := geos-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://trac.osgeo.org/geos/
$(PKG)_URL      := http://download.osgeo.org/geos/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.remotesensing.org/geos/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://geos.refractions.net/' | \
    $(SED) -n 's,.*geos-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,-lgeos,-lgeos -lstdc++,' '$(1)/tools/geos-config.in'
    $(SED) -i 's,-L\$${libdir}$$,-L$${libdir} -lgeos -lstdc++,' '$(1)/tools/geos-config.in'
    $(SED) -i 's,\$$WARNFLAGS -ansi,\$$WARNFLAGS,' '$(1)/configure.in'
    touch '$(1)/aclocal.m4'
    $(SED) -i 's,\$$WARNFLAGS -ansi,\$$WARNFLAGS,' '$(1)/configure'
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
