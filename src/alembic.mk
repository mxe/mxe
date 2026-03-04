# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := alembic
$(PKG)_DESCR    := Alembic C++ scene data framework
$(PKG)_WEBSITE  := https://www.alembic.io/
$(PKG)_IGNORE   :=
# Workaround for cross-compilation issue: https://github.com/alembic/alembic/issues/488
$(PKG)_VERSION  := 1.8.10-fix-windows
$(PKG)_CHECKSUM := 9fac60328d476446d5c9cf0923ce3e2f97f03dce8328c8b33e475d8afe2f55bd
$(PKG)_GH_CONF  := hkunz/alembic/tags
$(PKG)_DEPS     := cc imath hdf5 zlib

define $(PKG)_BUILD
    rm -f "$(BUILD_DIR)/CMakeCache.txt"
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMAKE_INSTALL_PREFIX=$(PREFIX)/$(TARGET) \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DBUILD_STATIC_LIBS=$(CMAKE_STATIC_BOOL) \
        -DUSE_HDF5=ON \
        -DUSE_PTEX=OFF \
        -DUSE_PRMAN=OFF \
        -DUSE_MAYA=OFF \
        -DUSE_PYTHON=OFF \
        -DImath_INCLUDE_DIR=$(PREFIX)/$(TARGET)/include \
        -DImath_LIBRARY=$(PREFIX)/$(TARGET)/lib/libImath.a \
        -DHDF5_ROOT=$(PREFIX)/$(TARGET)

    $(MAKE) -C "$(BUILD_DIR)" -j "$(JOBS)"
    $(MAKE) -C "$(BUILD_DIR)" -j 1 install

    '$(TARGET)-g++' \
        -I '$(PREFIX)/$(TARGET)/include' \
        -L '$(PREFIX)/$(TARGET)/lib' \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-alembic.exe' \
        -lAlembic \
        -lImath-3_2 \
        -lhdf5 \
        -lz
endef
