# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GD  (without support for xpm)
PKG             := gd
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.35
$(PKG)_CHECKSUM := ccf34a610abff2dbf133a20c4d2a4aa94939018a
$(PKG)_SUBDIR   := gd-$($(PKG)_VERSION)
$(PKG)_FILE     := gd-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.libgd.org/
$(PKG)_URL      := http://www.libgd.org/releases/$($(PKG)_FILE)
$(PKG)_URL_2    := http://www.libgd.org/releases/oldreleases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc freetype libpng jpeg libxml2 pthreads

define $(PKG)_UPDATE
    wget -q -O- 'http://www.libgd.org/releases/' | \
    $(SED) -n 's,.*gd-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    touch '$(1)/aclocal.m4'
    touch '$(1)/config.hin'
    touch '$(1)/Makefile.in'
    $(SED) -i 's,-I@includedir@,-I@includedir@ -DNONDLL,' '$(1)/config/gdlib-config.in'
    $(SED) -i 's,-lX11 ,,g'     '$(1)/configure'
    $(SED) -i 's,png12,png14,g' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-freetype='$(PREFIX)/$(TARGET)' \
        --without-x \
        LIBPNG_CONFIG='$(PREFIX)/$(TARGET)/bin/libpng-config' \
        CFLAGS='-DNONDLL -DXMD_H -L$(PREFIX)/$(TARGET)/lib' \
        LIBS="`$(PREFIX)/$(TARGET)/bin/xml2-config --libs`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
