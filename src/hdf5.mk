# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := hdf5
$(PKG)_WEBSITE  := https://www.hdfgroup.org/hdf5/
$(PKG)_DESCR    := HDF5
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.14.6
$(PKG)_CHECKSUM := e4defbac30f50d64e1556374aa49e574417c9e72c6b1de7a4ff88c4b1bea6e9b
$(PKG)_SUBDIR   := hdf5-$($(PKG)_VERSION)
$(PKG)_FILE     := hdf5-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/HDFGroup/hdf5/releases/download/hdf5_$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc pthreads zlib

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1)/.build'
    cd '$(1)/.build' && $(TARGET)-cmake \
        -DBUILD_TESTING=OFF \
        -DHDF5_INSTALL_DATA_DIR='share/hdf5' \
        -DHDF5_INSTALL_CMAKE_DIR='lib/cmake' \
        -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON \
        -DONLY_SHARED_LIBS:BOOL=$(if $(BUILD_SHARED),ON,OFF) \
        '$(1)'

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)'
    $(MAKE) -C '$(1)/.build' -j 1 install

    # Remove version suffix from pkg-config files (no longer needed in 1.14.6)

    # by error there is -lfull_path_to_libz.a
    $(SED) -i -e 's!-l[^ ]*libz\(.dll\)\?\.a!-lz!g' '$(PREFIX)/$(TARGET)/lib/pkgconfig/hdf5.pc'
    $(SED) -i -e 's!-l[^ ]*libsz\(.dll\)\?\.a!-lsz!g' '$(PREFIX)/$(TARGET)/lib/pkgconfig/hdf5.pc'

    # by error, -lhdf5 is last, move it to the front of the list
    $(SED) -i -e 's!Libs.private:\(.*\)-lhdf5$$!Libs.private: -lhdf5\1!g' \
        '$(PREFIX)/$(TARGET)/lib/pkgconfig/hdf5.pc'

    # Test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -pedantic -Wno-error=unused-but-set-variable \
        '$(SOURCE_DIR)/HDF5Examples/C/TUTR/h5_write.c' -o '$(PREFIX)/$(TARGET)/bin/test-hdf5-link.exe' \
        `'$(TARGET)-pkg-config' hdf5 --cflags --libs`

    # Another test
    '$(TARGET)-g++' \
        -W -Wall -Werror -std=c++11 -pedantic \
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
