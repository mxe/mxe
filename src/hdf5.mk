# This file is part of MXE.
# See index.html for further information.

PKG             := hdf5
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.12
$(PKG)_CHECKSUM := 6d080f913a226a3ce390a11d9b571b2d5866581a2aa4434c398cd371c7063639
$(PKG)_SUBDIR   := hdf5-$($(PKG)_VERSION)
$(PKG)_FILE     := hdf5-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.hdfgroup.org/ftp/HDF5/releases/$($(PKG)_SUBDIR)/src/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pthreads zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.hdfgroup.org/ftp/HDF5/current/src/' | \
    grep '<a href.*hdf5.*bz2' | \
    $(SED) -n 's,.*hdf5-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # automake 1.13 needs this directory to exist
    [ -d '$(1)/m4' ] || mkdir '$(1)/m4'
    cd '$(1)' && autoreconf --force --install
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-cxx \
        --disable-direct-vfd \
        --with-pthread='$(PREFIX)' \
        --with-zlib='$(PREFIX)' \
        AR='$(TARGET)-ar' \
        CPPFLAGS='-DH5_HAVE_WIN32_API \
                  -DH5_HAVE_MINGW \
                  -DHAVE_WINDOWS_PATH \
                  -DH5_BUILT_AS_$(if $(BUILD_STATIC),STATIC,DYNAMIC)_LIB'

    # libtool is somehow created to effectively disallow shared builds
    $(SED) -i 's,allow_undefined_flag="unsupported",allow_undefined_flag="",g' '$(1)/libtool'

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
    # generated sources are mostly tied to CPU
    # and don't vary with static/shared
    cp '$(1)/mxe-generated-sources/$(word 1,$(subst ., ,$(TARGET)))/'*.c '$(1)/src/'

    for d in src c++/src hl/src hl/c++/src; do \
        $(MAKE) -C '$(1)'/$$d -j '$(JOBS)' && \
        $(MAKE) -C '$(1)'/$$d -j 1 install; \
    done

    # install prefixed wrapper scripts
    $(INSTALL) -m755 '$(1)'/tools/misc/h5cc '$(PREFIX)/bin/$(TARGET)-h5cc'
    $(INSTALL) -m755 '$(1)'/c++/src/h5c++   '$(PREFIX)/bin/$(TARGET)-h5c++'

    # setup cmake toolchain
    (echo 'set(HDF5_C_COMPILER_EXECUTABLE $(PREFIX)/bin/$(TARGET)-h5cc)'; \
     echo 'set(HDF5_CXX_COMPILER_EXECUTABLE $(PREFIX)/bin/$(TARGET)-h5c++)'; \
     ) > '$(CMAKE_TOOLCHAIN_DIR)/$(PKG).cmake'

    ## test hdf5
    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-hdf5.exe' \
        -lhdf5_hl -lhdf5 -lz
endef
