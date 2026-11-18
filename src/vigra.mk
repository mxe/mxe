# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := vigra
$(PKG)_WEBSITE  := https://ukoethe.github.io/vigra/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.12.4
$(PKG)_CHECKSUM := fa516eeb19f72ae98a6d5a284c033bc0e0070cb73a8c72985696d2ad73a9292a
$(PKG)_GH_CONF  := ukoethe/vigra/tags, Version-,,,-
$(PKG)_DEPS     := cc jpeg libpng openexr tiff zlib

define $(PKG)_BUILD
    '$(TARGET)-cmake' -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        $(if $(BUILD_STATIC),-DVIGRA_STATIC_LIB=1,) \
        -DWITH_HDF5=OFF \
        -DWITH_VIGRANUMPY=OFF \
        -DWITH_VALGRIND=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' install

    $(TARGET)-g++ \
        '$(TEST_FILE)' -o $(PREFIX)/$(TARGET)/bin/test-vigra.exe \
        -DVIGRA_STATIC_LIB \
        -lvigraimpex `'$(TARGET)-pkg-config' OpenEXR libtiff-4 libpng --cflags --libs` -ljpeg
endef
