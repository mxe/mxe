# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# hdf5
PKG             := hdf5
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.8
$(PKG)_CHECKSUM := 1bc16883ecd631840b70857bea637a06eb0155da
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.hdfgroup.org
$(PKG)_URL      := http://www.hdfgroup.org/ftp/HDF5/current/src/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.hdfgroup.org/ftp/HDF5/current/src/' | \
    $(SED) -n 's,.*hdf5-\([0-9][^>]*\)\.tar.bz2*,\1,ip' | \
    head -1
endef


# Instructions can be found here
#   http://www.hdfgroup.org/ftp/HDF5/current/src/unpacked/release_docs/INSTALL_MinGW.txt

define $(PKG)_BUILD
    cd '$(1)' &&  ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-cxx --enable-fortran
    $(MAKE) -C '$(1)' -j '$(JOBS)' lib
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef

