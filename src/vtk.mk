# This file is part of MXE. See LICENSE.md for licensing information.

PKG               := vtk
$(PKG)_IGNORE     :=
$(PKG)_VERSION    := 8.0.0
$(PKG)_CHECKSUM   := c7e727706fb689fb6fd764d3b47cac8f4dc03204806ff19a10dfd406c6072a27
$(PKG)_SUBDIR     := VTK-$($(PKG)_VERSION)
$(PKG)_FILE       := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL        := http://www.vtk.org/files/release/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_QT_VERSION := 5
$(PKG)_DEPS       := gcc hdf5 qtbase qttools libpng expat libxml2 jsoncpp tiff freetype lz4 hdf5 libharu glew

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://vtk.org/gitweb?p=VTK.git;a=tags' | \
    grep 'refs/tags/v[0-9.]*"' | \
    $(SED) 's,.*refs/tags/v\(.*\)".*,\1,g;' | \
    grep -v rc | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    # first we need a native build to create the compile tools
    mkdir '$(1).native_build'
    cd '$(1).native_build' && '$(PREFIX)/$(BUILD)/bin/cmake' \
        -DBUILD_TESTING=FALSE \
        -DCMAKE_BUILD_TYPE="Release" \
        '$(1)'
    $(MAKE) -C '$(1).native_build' -j '$(JOBS)' VERBOSE=1 vtkCompileTools

    # DirectX is detected on Mac OSX but we use OpenGL
    $(SED) -i 's,d3d9,nod3d9,g' '$(1)/CMake/FindDirectX.cmake'

    # now the cross compilation
    mkdir '$(1).cross_build'
    cd '$(1).cross_build' && '$(TARGET)-cmake' \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DVTKCompileTools_DIR='$(1).native_build' \
        -DBUILD_SHARED_LIBS=$(if $(BUILD_STATIC),FALSE,TRUE) \
        -DVTK_Group_Qt=ON \
        -DVTK_Group_Imaging=ON \
        -DVTK_QT_VERSION=$($(PKG)_QT_VERSION) \
        -DVTK_USE_CXX11_FEATURES=ON \
        -DVTK_USE_SYSTEM_LIBRARIES=OFF \
        -DVTK_USE_SYSTEM_LIBPROJ4=OFF \
        -DVTK_USE_SYSTEM_NETCDF=OFF \
        -DVTK_USE_SYSTEM_NETCDFCPP=OFF \
        -DVTK_USE_SYSTEM_GL2PS=OFF \
        -DVTK_USE_SYSTEM_TIFF=ON \
        -DVTK_USE_SYSTEM_HDF5=ON \
        -DVTK_USE_SYSTEM_GLEW=ON \
        -DVTK_FORBID_DOWNLOADS=ON \
        -DVTK_USE_SYSTEM_LIBHARU=ON \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTING=OFF \
        '$(1)'
    $(MAKE) -C '$(1).cross_build' -j '$(JOBS)' VERBOSE=1 install

    #now build the GUI -> Qt -> SimpleView Example
    mkdir '$(1).test'
    cd '$(1).test' && '$(TARGET)-cmake' \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        '$(1)/Examples/GUI/Qt/SimpleView'
    $(MAKE) -C '$(1).test' -j '$(JOBS)' VERBOSE=1
    $(INSTALL) '$(1).test/SimpleView.exe' $(PREFIX)/$(TARGET)/bin/test-$(PKG).exe
endef
