# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := hdf5
$(PKG)_WEBSITE  := https://www.hdfgroup.org/hdf5/
$(PKG)_DESCR    := HDF5
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.12.0
$(PKG)_CHECKSUM := 97906268640a6e9ce0cde703d5a71c9ac3092eded729591279bf2e3ca9765f61
$(PKG)_SUBDIR   := hdf5-$($(PKG)_VERSION)
$(PKG)_FILE     := hdf5-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-$(call SHORT_PKG_VERSION,$(PKG))/hdf5-$($(PKG)_VERSION)/src/$($(PKG)_FILE)
$(PKG)_DEPS     := cc pthreads zlib aec

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    # Based on mxe-octave
    mkdir '$(1)/pregen'
    mkdir '$(1)/pregen/shared'
    $(if $(findstring x86_64, $(TARGET)), \
      cp '$(1)/src/H5Tinit.c.mingw64' '$(1)/pregen/H5Tinit.c'
      cp '$(1)/src/H5lib_settings.c.mingw64' '$(1)/pregen/H5lib_settings.c'
      cp '$(1)/src/H5Tinit.c.mingw64' '$(1)/pregen/shared/H5Tinit.c'
      cp '$(1)/src/H5lib_settings.c.mingw64' '$(1)/pregen/shared/H5lib_settings.c',
      $(if $(findstring i686, $(TARGET)), \
        cp '$(1)/src/H5Tinit.c.mingw32' '$(1)/pregen/H5Tinit.c'
        cp '$(1)/src/H5lib_settings.c.mingw32' '$(1)/pregen/H5lib_settings.c'
        cp '$(1)/src/H5Tinit.c.mingw32' '$(1)/pregen/shared/H5Tinit.c'
        cp '$(1)/src/H5lib_settings.c.mingw32' '$(1)/pregen/shared/H5lib_settings.c',
        $(error "Unexpected Target $(TARGET)")
      )
    )

    mkdir '$(1)/.build'
    cd '$(1)/.build' && $(TARGET)-cmake \
            -DHDF5_USE_PREGEN=ON \
            -DHAVE_IOEO_EXITCODE=0 \
            -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON \
            -DH5_LDOUBLE_TO_LONG_SPECIAL_RUN=1 \
            -DH5_LDOUBLE_TO_LONG_SPECIAL_RUN__TRYRUN_OUTPUT="" \
            -DH5_LONG_TO_LDOUBLE_SPECIAL_RUN=1 \
            -DH5_LONG_TO_LDOUBLE_SPECIAL_RUN__TRYRUN_OUTPUT="" \
            -DH5_LDOUBLE_TO_LLONG_ACCURATE_RUN=0 \
            -DH5_LDOUBLE_TO_LLONG_ACCURATE_RUN__TRYRUN_OUTPUT="" \
            -DH5_LLONG_TO_LDOUBLE_CORRECT_RUN=0 \
            -DH5_LLONG_TO_LDOUBLE_CORRECT_RUN__TRYRUN_OUTPUT="" \
            -DH5_DISABLE_SOME_LDOUBLE_CONV_RUN=1 \
            -DH5_DISABLE_SOME_LDOUBLE_CONV_RUN__TRYRUN_OUTPUT="" \
            -DH5_NO_ALIGNMENT_RESTRICTIONS_RUN=0 \
            -DH5_NO_ALIGNMENT_RESTRICTIONS_RUN__TRYRUN_OUTPUT="" \
            -DH5_PRINTF_LL_TEST_RUN=1 \
            -DH5_PRINTF_LL_TEST_RUN__TRYRUN_OUTPUT="" \
            -DTEST_LFS_WORKS_RUN=0 \
            -DBUILD_TESTING=OFF \
            -DHDF5_USE_PREGEN_DIR='$(1)/pregen' \
            -DHDF5_INSTALL_DATA_DIR='share/hdf5' \
            -DHDF5_INSTALL_CMAKE_DIR='lib/cmake' \
            -DHDF5_ENABLE_SZIP_SUPPORT:BOOL=ON \
            -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON \
            -DONLY_SHARED_LIBS:BOOL=$(if $(BUILD_SHARED),ON,OFF) \
        '$(1)'

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)'
    $(MAKE) -C '$(1)/.build' -j 1 install

    # Remove version suffix from pkg-config files
    mv '$(PREFIX)/$(TARGET)/lib/pkgconfig/hdf5-$($(PKG)_VERSION).pc' \
       '$(PREFIX)/$(TARGET)/lib/pkgconfig/hdf5.pc'
    mv '$(PREFIX)/$(TARGET)/lib/pkgconfig/hdf5_hl-$($(PKG)_VERSION).pc' \
       '$(PREFIX)/$(TARGET)/lib/pkgconfig/hdf5_hl.pc'
    mv '$(PREFIX)/$(TARGET)/lib/pkgconfig/hdf5_cpp-$($(PKG)_VERSION).pc' \
       '$(PREFIX)/$(TARGET)/lib/pkgconfig/hdf5_cpp.pc'
    mv '$(PREFIX)/$(TARGET)/lib/pkgconfig/hdf5_hl_cpp-$($(PKG)_VERSION).pc' \
       '$(PREFIX)/$(TARGET)/lib/pkgconfig/hdf5_hl_cpp.pc'

    # by error there is -lfull_path_to_libz.a
    $(SED) -i -e 's!-l[^ ]*libz\(.dll\)\?\.a!-lz!g' '$(PREFIX)/$(TARGET)/lib/pkgconfig/hdf5.pc'
    $(SED) -i -e 's!-l[^ ]*libsz\(.dll\)\?\.a!-lsz!g' '$(PREFIX)/$(TARGET)/lib/pkgconfig/hdf5.pc'

    # by error, -lhdf5 is last, move it to the front of the list
    $(SED) -i -e 's!Libs.private:\(.*\)-lhdf5$$!Libs.private: -lhdf5\1!g' \
        '$(PREFIX)/$(TARGET)/lib/pkgconfig/hdf5.pc'

    # Test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -pedantic -Wno-error=unused-but-set-variable \
        '$(SOURCE_DIR)/examples/h5_write.c' -o '$(PREFIX)/$(TARGET)/bin/test-hdf5-link.exe' \
        `'$(TARGET)-pkg-config' hdf5 --cflags --libs`

    # Another test
    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(PWD)/src/$(PKG)-test.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-hdf5.exe' \
        `'$(TARGET)-pkg-config' hdf5_hl --cflags --libs`

    # Test cmake can find hdf5
    mkdir '$(1).test-cmake'
    cd '$(1).test-cmake' && '$(TARGET)-cmake' \
        -DPKG=$(PKG) \
        -DPKG_VERSION=$($(PKG)_VERSION) \
        -DHDF5_FIND_DEBUG=ON \
        -DHDF5_USE_STATIC_LIBRARIES=$(CMAKE_STATIC_BOOL) \
        '$(PWD)/src/cmake/test'
    $(MAKE) -C '$(1).test-cmake' -j 1 install VERBOSE=ON

endef
