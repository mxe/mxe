# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := vigra
$(PKG)_WEBSITE  := https://ukoethe.github.io/vigra/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.0
$(PKG)_CHECKSUM := dc041f7ccf838d4321e9bcf522fece1758768dd7a3f8350d1e83e2b8e6daf1e6
$(PKG)_GH_CONF  := ukoethe/vigra/tags, Version-,,,-
$(PKG)_DEPS     := cc jpeg libpng openexr tiff

define $(PKG)_BUILD
    # Make sure the package gets built statically
    # NB: we're not actually building vigranumpy, but preparing it in case we ever will won't hurt
    $(SED) -i 's,\bSHARED\b,STATIC,' '$(1)/src/impex/CMakeLists.txt'
    $(SED) -i 's,\bSHARED\b,STATIC,' '$(1)/config/VIGRA_ADD_NUMPY_MODULE.cmake'
    $(SED) -i 's,\bSHARED\b,STATIC,' '$(1)/vigranumpy/test/CMakeLists.txt'
    mkdir '$(1)/build'
    cd '$(1)/build' && '$(TARGET)-cmake' .. \
        -DVIGRA_STATIC_LIB=1 \
        -DWITH_HDF5=OFF \
        -DWITH_VIGRANUMPY=OFF \
        -DWITH_VALGRIND=OFF
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install

    $(TARGET)-g++ \
        '$(TEST_FILE)' -o $(PREFIX)/$(TARGET)/bin/test-vigra.exe \
        -DVIGRA_STATIC_LIB \
        -lvigraimpex `'$(TARGET)-pkg-config' OpenEXR libtiff-4 libpng --cflags --libs` -ljpeg
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =

$(PKG)_BUILD_SHARED =
