# This file is part of MXE.
# See index.html for further information.

PKG             := hdf5
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.12
$(PKG)_CHECKSUM := 9b266ebde9287130fc07ce9f07f20cd0f753591b
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
        CPPFLAGS="-DH5_HAVE_WIN32_API -DH5_HAVE_MINGW -DH5_BUILT_AS_STATIC_LIB" \
        AR='$(TARGET)-ar'

    # These programs need to be executed on host to create
    # H5lib_settings.c and H5Tinit.c
    for f in H5detect.exe H5make_libsettings.exe libhdf5.settings; do \
        $(MAKE)       -C '$(1)'/src $$f && \
        $(INSTALL) -m755 '$(1)'/src/$$f '$(PREFIX)/$(TARGET)/bin/'; \
    done
    (echo 'mkdir $(TARGET)'; \
     echo 'H5detect.exe > $(TARGET)\H5Tinit.c'; \
     echo 'H5make_libsettings.exe > $(TARGET)\H5lib_settings.c';) \
     > '$(PREFIX)/$(TARGET)/bin/hdf5-create-settings.bat'
    cp '$(1)/mxe-generated-sources/$(TARGET)/'*.c '$(1)/src/'

    $(MAKE) -C '$(1)'/src -j '$(JOBS)'
    $(MAKE) -C '$(1)'/src -j 1 install
    $(MAKE) -C '$(1)'/c++/src -j '$(JOBS)'
    $(MAKE) -C '$(1)'/c++/src -j 1 install
    $(MAKE) -C '$(1)'/hl/src -j '$(JOBS)'
    $(MAKE) -C '$(1)'/hl/src -j 1 install
    $(MAKE) -C '$(1)'/hl/c++/src -j '$(JOBS)'
    $(MAKE) -C '$(1)'/hl/c++/src -j 1 install

    # install prefixed wrapper scripts
    $(INSTALL) -m755 '$(1)'/tools/misc/h5cc '$(PREFIX)/bin/$(TARGET)-h5cc'
    $(INSTALL) -m755 '$(1)'/c++/src/h5c++   '$(PREFIX)/bin/$(TARGET)-h5c++'

    ## test hdf5
    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-hdf5.exe' \
        -lhdf5_hl -lhdf5 -lz
endef
