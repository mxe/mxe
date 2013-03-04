# This file is part of MXE.
# See index.html for further information.

PKG             := openmpi
$(PKG)_CHECKSUM := 38095d3453519177272f488d5058a98f7ebdbf10
$(PKG)_SUBDIR   := openmpi-$($(PKG)_VERSION)
$(PKG)_FILE     := openmpi-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.open-mpi.org/software/ompi/v1.6/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.open-mpi.org/software/ompi/' | \
    $(SED)  -n 's,.*downloads/openmpi-([0-9]\.[0-9\.]*).tar.bz2">.*,\1,p' | \
    head -1 | echo 
endef

define $(PKG)_BUILD
    #$(SED) -i 's,aclocal,aclocal -I $(PREFIX)/$(TARGET)/share/aclocal,' '$(1)/autogen.sh'
    #$(SED) -i 's,libtoolize,$(LIBTOOLIZE),'                             '$(1)/autogen.sh'

    cd '$(1)' &&  ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'

    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

endef

#$(PKG)_BUILD_x86_64-w64-mingw32 =
