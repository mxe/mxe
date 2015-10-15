# This file is part of MXE.
# See index.html for further information.

PKG             := vigra
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.0
$(PKG)_CHECKSUM := 8fbdccb553a4925323098ab27b710fbc87d48f37bf81d404994936a31a31cf01
$(PKG)_SUBDIR   := vigra-$(word 1,$(subst -, ,$($(PKG)_VERSION)))
$(PKG)_FILE     := vigra-$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL      := http://hci.iwr.uni-heidelberg.de/vigra-old-versions/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc jpeg libpng openexr tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- "https://api.github.com/repos/ukoethe/vigra/releases" | \
    grep 'tag_name' | \
    $(SED) -n 's,.*tag_name": "Version-\([0-9][^>]*\)".*,\1,p' | \
    tr '-' '.' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    # Make sure the package gets built statically
    # NB: we're not actually building vigranumpy, but preparing it in case we ever will won't hurt
    $(SED) -i 's,\bSHARED\b,STATIC,' '$(1)/src/impex/CMakeLists.txt'
    $(SED) -i 's,\bSHARED\b,STATIC,' '$(1)/config/VIGRA_ADD_NUMPY_MODULE.cmake'
    $(SED) -i 's,\bSHARED\b,STATIC,' '$(1)/vigranumpy/test/CMakeLists.txt'
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DLIBTYPE=STATIC \
        -DVIGRA_STATIC_LIB=1 \
        -DWITH_HDF5=OFF \
        -DWITH_VIGRANUMPY=OFF \
        -DWITH_VALGRIND=OFF
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install

    $(TARGET)-g++ \
        '$(2).cpp' -o $(PREFIX)/$(TARGET)/bin/test-vigra.exe \
        -DVIGRA_STATIC_LIB \
        -lvigraimpex `'$(TARGET)-pkg-config' OpenEXR libtiff-4 libpng --cflags --libs` -ljpeg
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =

$(PKG)_BUILD_SHARED =
