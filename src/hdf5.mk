# This file is part of MXE.
# See index.html for further information.

PKG             := hdf5
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 458cb91496e313debd55d52a7f89459a5469cceb
$(PKG)_SUBDIR   := hdf5-$($(PKG)_VERSION)
$(PKG)_FILE     := hdf5-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.hdfgroup.org/ftp/HDF5/current/src/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.hdfgroup.org/ftp/HDF5/current/src/' | \
    grep '<a href.*hdf5.*bz2' | \
    $(SED) -n 's,.*hdf5-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # automake 1.13 needs this directory to exist
    [ -d '$(1)/m4' ] || mkdir '$(1)/m4'
    cd '$(1)' && autoreconf --force --install && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --enable-cxx \
        --disable-direct-vfd \
        --prefix='$(PREFIX)/$(TARGET)' \
        CPPFLAGS="-DH5_HAVE_WIN32_API -DH5_HAVE_MINGW" \
        AR='$(TARGET)-ar'
    $(MAKE) -C '$(1)'/src -j '$(JOBS)'
    $(MAKE) -C '$(1)'/src -j 1 install
    $(MAKE) -C '$(1)'/c++/src -j '$(JOBS)'
    $(MAKE) -C '$(1)'/c++/src -j 1 install
    $(MAKE) -C '$(1)'/hl/src -j '$(JOBS)'
    $(MAKE) -C '$(1)'/hl/src -j 1 install
    $(MAKE) -C '$(1)'/hl/c++/src -j '$(JOBS)'
    $(MAKE) -C '$(1)'/hl/c++/src -j 1 install

    ## test hdf5
    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-hdf5.exe' \
        -lhdf5_hl -lhdf5 -lz
endef
