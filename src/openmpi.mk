# This file is part of MXE.
# See index.html for further information.

PKG             := openmpi
$(PKG)_VERSION  := 1.6.5
$(PKG)_CHECKSUM := 93859d515b33dd9a0ee6081db285a2d1dffe21ce
$(PKG)_SUBDIR   := openmpi-$($(PKG)_VERSION)
$(PKG)_FILE     := openmpi-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.open-mpi.org/software/ompi/v1.6/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.open-mpi.org/software/ompi/' | \
    $(SED)  -n 's,.*<TITLE>Open MPI: Version \([0-9\.]{1-6}\)</TITLE>.*,\1,p' | \
    head -1 | echo 
endef

define $(PKG)_BUILD
    #$(SED) -i 's,aclocal,aclocal -I $(PREFIX)/$(TARGET)/share/aclocal,' '$(1)/autogen.sh'
    #$(SED) -i 's,libtoolize,$(LIBTOOLIZE),'                             '$(1)/autogen.sh'

    #cd '$(1)' &&  ./autogen.sh

    cd '$(1)' && CPPAS=$(TARGET)-gcc ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
	--disable-mpi-f77 \
	--disable-mpi-f90

    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

endef

$(PKG)_BUILD_i686-pc-mingw32 =
$(PKG)_BUILD_i686-w64-mingw32 =
$(PKG)_BUILD_x86_64-w64-mingw32 =
