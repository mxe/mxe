# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# vigra
PKG             := vigra
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.7.1
$(PKG)_CHECKSUM := f90f54da31a6544057c25df7dbcc6954604de079
$(PKG)_SUBDIR   := vigra-$(word 1,$(subst -, ,$($(PKG)_VERSION)))
$(PKG)_FILE     := vigra-$($(PKG)_VERSION)-src.tar.gz
$(PKG)_WEBSITE  := http://hci.iwr.uni-heidelberg.de/vigra
$(PKG)_URL      := $($(PKG)_WEBSITE)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc jpeg tiff libpng

define $(PKG)_UPDATE
    wget -q -O- 'http://hci.iwr.uni-heidelberg.de/vigra/' | \
    grep 'Sources' | \
    grep '<a href="vigra' | \
    $(SED) -n 's,.*"vigra-\([0-9][^"]*\)-src.*,\1,p' | \
    head
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

    $(TARGET)-gcc \
        '$(2).cpp' -o $(PREFIX)/$(TARGET)/bin/test-vigra.exe \
        -DVIGRA_STATIC_LIB \
        -lvigraimpex -ltiff -lpng -ljpeg -lz -lstdc++
endef

