# This file is part of MXE.
# See index.html for further information.

PKG             := vtk7
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.0.0
$(PKG)_CHECKSUM := 78a990a15ead79cdc752e86b83cfab7dbf5b7ef51ba409db02570dbdd9ec32c3
$(PKG)_SUBDIR   := VTK-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := http://www.vtk.org/files/release/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc hdf5 qtbase qttools libpng expat libxml2 jsoncpp cmake tiff

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
    cd '$(1).native_build' && $(PREFIX)/$(BUILD)/bin/cmake \
        -DVTK_BUILD_ALL_MODULES=FALSE \
        -DVTK_Group_Rendering=FALSE \
        -DVTK_Group_StandAlone=FALSE \
        -DVTK_Group_CompileTools=TRUE \
        -DBUILD_TESTING=FALSE \
        -DCMAKE_BUILD_TYPE="Release" \
        '$(1)'
    $(MAKE) -C '$(1).native_build' -j '$(JOBS)' VERBOSE=1 vtkCompileTools

    # DirectX is detected on Mac OSX but we use OpenGL
    $(SED) -i 's,d3d9,nod3d9,g' '$(1)/CMake/FindDirectX.cmake'

    # now the cross compilation
    mkdir '$(1).cross_build'
    cd '$(1).cross_build' && $(PREFIX)/$(BUILD)/bin/cmake \
        -C '$(1)/TryRunResults.cmake' \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DVTKCompileTools_DIR='$(1).native_build' \
        -DBUILD_SHARED_LIBS=$(if $(BUILD_STATIC),FALSE,TRUE) \
        -DVTK_Group_Qt=ON \
        -DVTK_Group_Imaging=ON \
        -DVTK_QT_VERSION=5 \
        -DVTK_USE_CXX11_FEATURES=ON \
        -DVTK_USE_SYSTEM_LIBRARIES=ON \
        -DVTK_USE_SYSTEM_LIBPROJ4=OFF \
        -DVTK_USE_SYSTEM_NETCDF=OFF \
        -DVTK_FORBID_DOWNLOADS=ON \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTING=OFF \
        '$(1)'
    $(MAKE) -C '$(1).cross_build' -j '$(JOBS)' VERBOSE=1 || $(MAKE) -C '$(1).cross_build' -j 1 VERBOSE=1
    $(MAKE) -C '$(1).cross_build' -j 1 install VERBOSE=1

    #now build the GUI -> Qt -> SimpleView Example
    mkdir '$(1).test'
    cd '$(1).test' && $(PREFIX)/$(BUILD)/bin/cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        '$(1)/Examples/GUI/Qt/SimpleView'
    $(MAKE) -C '$(1).test' -j '$(JOBS)' VERBOSE=1
    $(INSTALL) '$(1).test/SimpleView.exe' $(PREFIX)/$(TARGET)/bin/test-vtk7.exe
endef
